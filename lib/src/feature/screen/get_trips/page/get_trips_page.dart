// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/screen/get_trips/cubit/get_trips_cubit.dart';
import 'package:trippy/src/feature/screen/get_trips/cubit/get_trips_state.dart';
import 'package:trippy/src/feature/screen/get_trips/models/get_trips_model_class.dart';
import 'package:trippy/src/feature/screen/get_trips_details/page/get_created_trips.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late TripCubit _tripCubit;

  @override
  void initState() {
    super.initState();
    _tripCubit = context.read<TripCubit>();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    await _tripCubit.getTrips();
  }

  Future<void> _refreshTrips() async {
    await _tripCubit.getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.appColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'images/icon.png',
              height: 40,
              width: 40,
            ),
            const Spacer(),
            const Texts(
              textAlign: TextAlign.center,
              texts: 'Created Trips',
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: BlocBuilder<TripCubit, TripState>(
        builder: (context, state) {
          if (state is TripInitial || state is TripLoading) {
            return Center(child: AppLoading());
          } else if (state is TripLoaded) {
            return RefreshIndicator(
              onRefresh: _refreshTrips,
              child: ListView.builder(
                itemCount: state.trips.length,
                itemBuilder: (context, index) {
                  return _buildTripCard(state.trips[index], () {
                    Get.to(
                      () => GetCreatedTripDetailsPage(
                          tripId: state.trips[index].id!),
                    );
                  });
                },
              ),
            );
          } else if (state is TripError) {
            return Center(child: Texts(texts: 'Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildTripCard(Data trip, void Function()? onTap) {
    return Containers(
      onTap: onTap,
      height: 350,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(2, 5), // 3D shadow effect
          ),
        ],
      ),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/orange.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Texts(
                      texts: trip.tripName ?? 'No Name',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    Texts(
                      texts: 'Type: ${trip.tripType ?? 'N/A'}',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    Texts(
                      texts:
                          'Date: ${trip.startDate ?? 'N/A'} - ${trip.endDate ?? 'N/A'}',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    Texts(
                      texts: 'Price: \$${trip.tripPrice ?? 'N/A'}',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    Texts(
                      texts: 'Description: ${trip.tripDescription ?? 'N/A'}',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
