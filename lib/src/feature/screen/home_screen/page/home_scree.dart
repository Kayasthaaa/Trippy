// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_cubit.dart';
import 'package:trippy/src/feature/screen/home_screen/cubit/home_screen_state.dart';
import 'package:trippy/src/feature/screen/home_screen/widgets/home_screen_card.dart';
import 'package:trippy/src/feature/screen/home_screen/widgets/sliders.dart';
import 'package:trippy/src/feature/screen/trip_details/page/trip_details_page.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';

import '../../create_trips/page/create_trips.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _sortAscending = true;
  late AnimationController _animationController;
  final int _displayedTripCount = 5;
  bool _showingAllTrips = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

//   The algorithm used here is a "Weighted Keyword Search with Relevance Scoring".
//  This algorithm combines elements from more complex information retrieval techniques like TF-IDF (
//   Term Frequency-Inverse Document Frequency) and cosine similarity,
//   but it's adapted for a simpler, in-memory context that's more suitable for a mobile app.
//    This algorithm implements a "Weighted Keyword Search with Relevance Scoring"
//   It combines elements of TF-IDF (Term Frequency-Inverse Document Frequency)
//   and cosine similarity concepts, adapted for a simpler, in-memory context.

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
      _animationController.reverse();
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
              texts: 'Trippy',
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
              final allTrips = state.userList!.data!.trips!;
              final filteredTrips = _searchTrips(allTrips, _searchQuery);
              final sortedTrips = _sortTrips(filteredTrips);

              return Column(
                children: [
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  Expanded(
                    child: _isSearching
                        ? _buildSearchResults(sortedTrips)
                        : _buildFullContent(sortedTrips),
                  ),
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

  Widget _buildSearchResults(List<dynamic> trips) {
    return trips.isEmpty
        ? const Center(child: Texts(texts: 'No matching trips found'))
        : ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Card_3D(
                imageUrl: trip.tripName!,
                title: trip.tripName!,
                desc: trip.tripDescription!,
                price: trip.tripPrice!,
              );
            },
          );
  }

  Widget _buildFullContent(List<dynamic> trips) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          _buildAboutUsSection(),
          _buildSlider(),
          _buildPastEventsSection(),
          _buildUpcomingTripsSection(trips),
        ],
      ),
    );
  }

  Widget _buildAboutUsSection() {
    return Containers(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: maxWidth(context),
      child: const Texts(
        texts: 'About Us',
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSlider() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(
            controller: _pageController,
            children: [
              buildSliderItem('images/imgtwo.jpg', 'Exciting Adventures'),
              buildSliderItem('images/guide.jpg', 'Guide Services'),
              buildSliderItem('images/pok.jpg', 'Pokhara Trips'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: const WormEffect(
            dotColor: Colors.grey,
            activeDotColor: Colors.blue,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildPastEventsSection() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Containers(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          width: maxWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Texts(
                texts: 'Past Events',
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              _buildCreateTripsButton(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildPastEventsList(),
      ],
    );
  }

  Widget _buildCreateTripsButton() {
    return Containers(
      onTap: () {
        Get.to(() => const TripPlannerPage());
      },
      width: 110,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(56, 183, 255, 1),
            Color.fromRGBO(131, 165, 255, 1),
          ],
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(width: 2),
          Texts(
            texts: 'Create trips',
            fontSize: 4,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 2),
        ],
      ),
    );
  }

  Widget _buildPastEventsList() {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          final List<String> images = [
            'purple.jpg',
            'pink.jpg',
            'mustang.jpg',
            'pok.jpg',
            'orange.jpg',
          ];
          final List<String> titles = [
            'Badamalika',
            'Mardi Trek',
            'Mustang',
            'Pokhara',
            'Chitlang'
          ];
          final List<String> prices = [
            '15000',
            '20000',
            '25000',
            '20000',
            '25000'
          ];
          final List<String> durations = [
            '3 days',
            '4 days',
            '5 days',
            '4 days',
            '5 days'
          ];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 310,
              width: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      'images/${images[index]}',
                      height: 310,
                      width: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NPR \n${prices[index]}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    left: 15,
                    right: 15,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Texts(
                            texts: titles[index],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          Texts(
                            texts: durations[index],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 202, 201, 201),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
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
                  setState(() {
                    _showingAllTrips = false; // Reset this when clearing search
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTripsSection(List<dynamic> trips) {
    final displayedTrips = _isSearching
        ? trips
        : (_showingAllTrips ? trips : trips.take(_displayedTripCount).toList());

    return Column(
      children: [
        const SizedBox(height: 10),
        Containers(
          margin: const EdgeInsets.symmetric(horizontal: 18.0),
          width: maxWidth(context),
          child: const Texts(
            texts: 'Upcoming Trips',
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedTrips.length,
          itemBuilder: (context, index) {
            final trip = displayedTrips[index];
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
        const SizedBox(height: 5),
        if (!_isSearching &&
            trips.length > _displayedTripCount &&
            !_showingAllTrips)
          Containers(
            onTap: () {
              setState(() {
                _showingAllTrips = true;
              });
            },
            width: maxWidth(context),
            child: const Center(child: Texts(texts: 'Show More Trips')),
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}
