import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/screen/get_trips_details/cubit/get_trip_details_cubit.dart';
import 'package:trippy/src/feature/screen/get_trips_details/cubit/get_trip_details_state.dart';
import 'package:trippy/src/feature/screen/get_trips_details/get_trips_details_api/get_trips_details_api.dart';
import 'package:trippy/src/feature/screen/get_trips_details/repo/get_trips_details_repo.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';

class GetCreatedTripDetailsPage extends StatelessWidget {
  final int tripId;

  const GetCreatedTripDetailsPage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetCreatedTripDetailsCubit(
        GetCreatedTripDetailsRepository(
          GetCreatedTripDetailsApi(),
        ),
      )..fetchTripDetails(tripId),
      child: Scaffold(
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
        body:
            BlocBuilder<GetCreatedTripDetailsCubit, GetCreatedTripDetailsState>(
          builder: (context, state) {
            if (state is GetTripDetailsLoading) {
              return Center(child: AppLoading());
            } else if (state is GetTripDetailsLoaded) {
              final tripDetails = state.tripDetails.data?.trip;
              final startLoc =
                  _parseLatLng(tripDetails?.tripLocation?.startLoc);
              final endLoc = _parseLatLng(tripDetails?.tripLocation?.endLoc);
              final stopOvers = tripDetails?.stopOvers
                      ?.map((stop) => _parseLatLng(stop.location))
                      .whereType<LatLng>()
                      .toList() ??
                  [];

              return Column(
                children: [
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: startLoc,
                        initialZoom: 2.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [startLoc, ...stopOvers, endLoc],
                              color: Colors.red,
                              strokeWidth: 3.0,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            _buildMarker(
                                startLoc,
                                Icons.play_arrow,
                                Colors.green,
                                tripDetails?.tripLocation?.startLocName ??
                                    "Start"),
                            _buildMarker(endLoc, Icons.stop, Colors.red,
                                tripDetails?.tripLocation?.endLocName ?? "End"),
                            ...List.generate(stopOvers.length, (index) {
                              final stopOver = tripDetails?.stopOvers?[index];
                              return _buildMarker(
                                  stopOvers[index],
                                  Icons.location_on,
                                  Colors.blue,
                                  stopOver?.location ?? "Stop ${index + 1}");
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Trip Name: ${tripDetails?.tripName ?? "N/A"}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            } else if (state is GetTripDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Select a trip to view details'));
          },
        ),
      ),
    );
  }

  LatLng _parseLatLng(String? locString) {
    if (locString == null) return const LatLng(0, 0);
    final parts = locString.split(',');
    if (parts.length != 2) return const LatLng(0, 0);
    return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
  }

  Marker _buildMarker(LatLng point, IconData icon, Color color, String label) {
    return Marker(
      point: point,
      width: 80,
      height: 80,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
