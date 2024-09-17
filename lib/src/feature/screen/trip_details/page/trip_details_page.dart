// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:trippy/src/constant/colors.dart';
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

class _TripDetailsPageState extends State<TripDetailsPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context
        .read<GetTripDetailsCubit>()
        .fetchTripDetails(widget.tripId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: const CustomAppBar(),
      body: BlocBuilder<GetTripDetailsCubit, GetTripDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: AppLoading()
                  .animate()
                  .fadeIn(duration: 600.ms), // Smooth fade-in animation
            );
          } else if (state.error != null) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.redAccent,
                ),
              ).animate().fadeIn(duration: 500.ms),
            );
          } else if (state.trips != null) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildTripImage(context)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: -0.3), // Smooth slide from top
                    const SizedBox(height: 30),
                    _buildTripDetails(context, state)
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .slideX(begin: -0.3),
                    const SizedBox(height: 30) // Slide from the left
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No trip details available.'),
            );
          }
        },
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
        // Neumorphism effect with subtle shadows
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
            trip.trip.tripName.capitalizeFirst.toString(),
            style: GoogleFonts.lato(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.ktextColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            trip.trip.tripDescription,
            style: GoogleFonts.lato(
              fontSize: 18,
              color: AppColor.ktextColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          _buildTripInfoRow(
              Icons.calendar_today, 'Start Date', trip.trip.startDate),
          _buildTripInfoRow(
              Icons.calendar_today_outlined, 'End Date', trip.trip.endDate),
          _buildTripInfoRow(
              Icons.access_time, 'Arrival Time', trip.trip.arrivalTime),
          _buildTripInfoRow(
              Icons.monetization_on, 'Price', '\$${trip.trip.tripPrice}'),
          _buildTripInfoRow(
              Icons.directions_car, 'Transport', trip.trip.meansOfTransport),
          const SizedBox(height: 30),
          _buildActionButton().animate().fadeIn(duration: 400.ms).scale(),
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
    return const Center(
      child: AppBtn(
        child: Texts(
          texts: 'Book Trip',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
