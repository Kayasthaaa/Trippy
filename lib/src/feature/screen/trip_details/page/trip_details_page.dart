// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/constant/loader.dart';
import 'package:trippy/src/constant/toaster.dart';
import 'package:trippy/src/feature/screen/post_enroll_trip/api/post_enroll_api.dart';
import 'package:trippy/src/feature/screen/post_enroll_trip/cubit/post_enroll_cubit.dart';
import 'package:trippy/src/feature/screen/post_enroll_trip/cubit/post_enroll_state.dart';
import 'package:trippy/src/feature/screen/post_enroll_trip/repo/post_enroll_repo.dart';
import 'package:trippy/src/feature/screen/trip_details/cubit/trip_details_cubit.dart';
import 'package:trippy/src/feature/screen/trip_details/cubit/trip_details_state.dart';
import 'package:trippy/src/feature/widgets/app_bar.dart';
import 'package:trippy/src/feature/widgets/app_btn.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';

class TripDetailsPage extends StatefulWidget {
  final int tripId;

  const TripDetailsPage({super.key, required this.tripId});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  late int _currentTripId;
  bool _isEnrolling = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTripId = widget.tripId;
    _fetchTripDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_currentTripId != widget.tripId) {
      setState(() {
        _currentTripId = widget.tripId;
      });
      _fetchTripDetails();
    }
  }

  void _fetchTripDetails() {
    context
        .read<GetTripDetailsCubit>()
        .fetchTripDetails(_currentTripId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetTripDetailsCubit>.value(
          value: context.read<GetTripDetailsCubit>(),
        ),
        BlocProvider<TripEnrollCubit>(
          create: (context) =>
              TripEnrollCubit(TripRepository(EnrollApiService())),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.appColor,
        appBar: const CustomAppBar(),
        body: BlocConsumer<GetTripDetailsCubit, GetTripDetailsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                  child: AppLoading().animate().fadeIn(duration: 600.ms));
            } else if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state.trips != null) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      _buildTripImage(context),
                      const SizedBox(height: 30),
                      _buildTripDetails(context, state),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No trip details available.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildTripImage(BuildContext context) {
    return Hero(
      tag: 'trip-${widget.tripId}',
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              spreadRadius: 5,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'images/pink.jpg',
            height: 350,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetails(BuildContext context, GetTripDetailsState state) {
    final trip = state.trips!.data;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip!.trip!.tripName!.capitalizeFirst.toString(),
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.ktextColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            trip.trip!.tripDescription.toString(),
            style: GoogleFonts.lato(
              fontSize: 18,
              color: AppColor.ktextColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          _buildTripInfoRow(
              Icons.calendar_today, 'Start Date', trip.trip!.startDate),
          _buildTripInfoRow(
              Icons.calendar_today_outlined, 'End Date', trip.trip!.endDate),
          _buildTripInfoRow(Icons.nature_people_outlined, 'People Enrolled',
              trip.trip!.totalPeople),
          _buildTripInfoRow(Icons.monetization_on, 'Price',
              'Nrs ${trip.trip!.tripPrice} - /'),
          _buildTripInfoRow(
              Icons.directions_car, 'Transport', trip.trip!.meansOfTransport),
          const SizedBox(height: 30),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildTripInfoRow(IconData icon, String title, String? info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColor.appThemeColor, size: 24),
          const SizedBox(width: 12),
          Text(
            '$title: $info',
            style: GoogleFonts.lato(fontSize: 16, color: AppColor.ktextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return BlocConsumer<TripEnrollCubit, TripEnrollState>(
      listener: (context, state) {
        if (state is TripEnrollSuccess) {
          setState(() {
            _isEnrolling = false;
            _isLoading = false;
          });
          ToasterService.success(message: 'Successfully enrolled in the trip!');
          _fetchTripDetails();
        } else if (state is TripEnrollError) {
          setState(() {
            _isEnrolling = false;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        final GetTripDetailsState tripDetailsState =
            context.watch<GetTripDetailsCubit>().state;
        final bool isEnrolled =
            tripDetailsState.trips?.data!.isEnrolled ?? false;

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: _buildBookTripButton(context),
          secondChild: _buildEnrolledButton(state),
          crossFadeState: isEnrolled ||
                  _isEnrolling ||
                  _isLoading ||
                  state is TripEnrollLoading
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ).animate().fadeIn(duration: 400.ms).scale();
      },
    );
  }

  Widget _buildBookTripButton(BuildContext context) {
    return AppBtn(
      onTap: () {
        setState(() {
          _isLoading = true;
        });
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isEnrolling = true;
            });
            context.read<TripEnrollCubit>().enrollTrip(_currentTripId);
          }
        });
      },
      child: const Texts(
        texts: 'Book Trip',
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEnrolledButton(TripEnrollState state) {
    return AppBtn(
      onTap: null, // Disable the button when enrolled or enrolling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading || _isEnrolling || state is TripEnrollLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: loading(),
            )
          else
            const Icon(
              Icons.done,
              color: Colors.white,
              size: 27,
            ),
          const SizedBox(width: 6),
          Texts(
            texts: _isLoading
                ? 'Processing...'
                : _isEnrolling || state is TripEnrollLoading
                    ? 'Enrolling...'
                    : 'Enrolled',
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          )
        ],
      ),
    );
  }
}
