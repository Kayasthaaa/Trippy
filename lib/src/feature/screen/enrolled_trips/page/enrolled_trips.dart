// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_cubit.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_state.dart';
import 'package:trippy/src/feature/screen/home_screen/widgets/home_screen_card.dart';
import 'package:trippy/src/feature/screen/trip_details/page/trip_details_page.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';

class EnrolledTripsPage extends StatefulWidget {
  const EnrolledTripsPage({super.key});

  @override
  _EnrolledTripsPageState createState() => _EnrolledTripsPageState();
}

class _EnrolledTripsPageState extends State<EnrolledTripsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final homeCubit = context.read<HomeCubit>();
    if (homeCubit.state.userList == null) {
      homeCubit.fetchUserList();
    }
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _isSearching = query.isNotEmpty;
    });
  }

  List<dynamic> _searchTrips(List<dynamic> trips, String query) {
    if (query.isEmpty) return trips;

    final keywords = query.toLowerCase().split(' ');

    const nameWeight = 3.0;
    const descriptionWeight = 2.0;
    const priceWeight = 1.0;

    double calculateRelevance(dynamic trip) {
      double score = 0.0;

      for (var keyword in keywords) {
        if (trip.tripName?.toLowerCase().contains(keyword) ?? false) {
          score += nameWeight;
        }
        if (trip.tripDescription?.toLowerCase().contains(keyword) ?? false) {
          score += descriptionWeight;
        }
        if (trip.tripPrice?.toString().contains(keyword) ?? false) {
          score += priceWeight;
        }
      }

      return score;
    }

    final filteredTrips =
        trips.where((trip) => calculateRelevance(trip) > 0).toList();
    filteredTrips
        .sort((a, b) => calculateRelevance(b).compareTo(calculateRelevance(a)));

    return filteredTrips;
  }

  void _setSortOrder(bool ascending) {
    setState(() {
      _sortAscending = ascending;
    });
  }

  List<dynamic> _sortTrips(List<dynamic> trips) {
    trips.sort((a, b) {
      final priceA = a.tripPrice ?? 0;
      final priceB = b.tripPrice ?? 0;
      return _sortAscending
          ? priceA.compareTo(priceB)
          : priceB.compareTo(priceA);
    });
    return trips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/icon.png',
              height: 40,
              width: 40,
            ),
            const Texts(
              texts: 'Enrolled Trips',
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            _buildSortButton(),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchData();
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: AppLoading());
            } else if (state.error != null) {
              return Center(child: Texts(texts: state.error!));
            } else if (state.userList != null) {
              final allTrips = state.userList!.data!.trips!
                  .where((trip) => trip.isEnrolled == true)
                  .toList();
              final filteredTrips = _searchTrips(allTrips, _searchQuery);
              final sortedTrips = _sortTrips(filteredTrips);

              return Column(
                children: [
                  const SizedBox(height: 15),
                  _buildSearchBar(),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sortedTrips.length,
                      itemBuilder: (context, index) {
                        final trip = sortedTrips[index];
                        return Card_3D(
                          onTap: () {
                            Get.to(() => TripDetailsPage(tripId: trip.id),
                                preventDuplicates: false);
                          },
                          imageUrl: trip.tripName!,
                          title: trip.tripName!,
                          desc: trip.tripDescription!,
                          price: trip.tripPrice!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return const Center(child: Texts(texts: 'No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<bool>(
      offset: const Offset(0, 40),
      onSelected: _setSortOrder,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
        const PopupMenuItem<bool>(
          value: false,
          child: Text('Highest to Lowest'),
        ),
        const PopupMenuItem<bool>(
          value: true,
          child: Text('Lowest to Highest'),
        ),
      ],
      child: const Icon(
        Icons.sort,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Containers(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: maxWidth(context),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            const Icon(Icons.search, size: 25, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _performSearch,
                decoration: const InputDecoration(
                  hintText: 'Search for Trips',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            if (_isSearching)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  _performSearch('');
                },
              ),
          ],
        ),
      ),
    );
  }
}
