// ignore_for_file: library_private_types_in_public_api, unused_field, unnecessary_to_list_in_spreads

import 'dart:async';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/route_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:trippy/bottom_navigation.dart';
import 'package:trippy/src/constant/app_spaces.dart';
import 'package:trippy/src/constant/colors.dart';
import 'package:trippy/src/constant/loader.dart';
import 'package:trippy/src/constant/toaster.dart';
import 'package:trippy/src/feature/screen/create_trips/api/create_trips_api.dart';
import 'package:trippy/src/feature/screen/create_trips/cubit/create_trip_cubit.dart';
import 'package:trippy/src/feature/screen/create_trips/cubit/create_trips_state.dart';
import 'package:trippy/src/feature/screen/create_trips/models/create_trips_models.dart';

import 'package:trippy/src/feature/widgets/app_btn.dart';
import 'package:trippy/src/feature/widgets/app_loading.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:trippy/src/feature/widgets/btn_text.dart';
import 'package:trippy/src/feature/widgets/containers.dart';
import 'package:trippy/src/feature/widgets/no_menu_bar.dart';

class TripPlannerPage extends StatefulWidget {
  const TripPlannerPage({super.key});

  @override
  _TripPlannerPageState createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage> {
  late MapController _mapController;
  final List<Marker> _markers = [];
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _waypointController = TextEditingController();
  String _searchAddress = '';
  LatLng? _initialLocation;
  LatLng? _destinationLocation;

  final List<Map<String, dynamic>> _waypoints = [];
  DateTime _focusedDay = DateTime.now();
  String? _selectedTransport;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _numberOfPeopleController =
      TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  final TileLayer _currentTileLayer = TileLayer(
    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    subdomains: const ['a', 'b', 'c'],
  );

  final LatLng _nepalCenter = const LatLng(28.3949, 84.1240);

  // Define bounds for Nepal
  final LatLngBounds _nepalBounds = LatLngBounds(
    const LatLng(26.3478, 80.0884), // Southwest corner
    const LatLng(30.4227, 88.1993), // Northeast corner
  );

  bool _isLoading = true;
  bool _isMapReady = false;
  String _startLocName = '';
  String _endLocName = '';
  late PostTripApiService _apiService;
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _checkLocationPermissionAndGetLocation();
    _apiService = PostTripApiService();
  }

  Trip _createTripFromState() {
    return Trip(
      name: _tripNameController.text.isNotEmpty
          ? _tripNameController.text
          : "Trip to Nepal",
      description: _commentsController.text,
      price: double.tryParse(_budgetController.text) ?? 0,
      startDate: _startDate ?? DateTime.now(),
      endDate: _endDate ?? DateTime.now(),
      arrivalTime: '8:00 PM', // You might want to add a field for this
      meansOfTransport: _selectedTransport ?? '',
      isPrivate: false, // Add a toggle for this if needed
      startLoc: _initialLocation != null
          ? "${_initialLocation!.latitude}, ${_initialLocation!.longitude}"
          : '',
      startLocName: _startLocName,
      endLoc: _destinationLocation != null
          ? "${_destinationLocation!.latitude}, ${_destinationLocation!.longitude}"
          : '',
      endLocName: _endLocName,
      locations: [
        if (_initialLocation != null)
          "${_initialLocation!.latitude}, ${_initialLocation!.longitude}",
        ..._waypoints
            .map((wp) =>
                "${wp['location'].latitude}, ${wp['location'].longitude}")
            .toList(),
        if (_destinationLocation != null)
          "${_destinationLocation!.latitude}, ${_destinationLocation!.longitude}",
      ],
    );
  }

  bool _validateForm() {
    if (_tripNameController.text.isEmpty ||
        _initialLocation == null ||
        _destinationLocation == null ||
        _startDate == null ||
        _endDate == null ||
        _selectedTransport == null ||
        _numberOfPeopleController.text.isEmpty ||
        _totalDaysController.text.isEmpty ||
        _budgetController.text.isEmpty) {
      ToasterService.error(message: 'Please fill in all required fields');
      return false;
    }
    return true;
  }

  Future<void> _checkLocationPermissionAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ToasterService.error(
          message:
              'Location services are disabled. Please enable them in your device settings.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToasterService.error(
            message:
                'Location permissions are denied. Please enable them in your app settings.');
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ToasterService.error(
          message:
              'Location permissions are permanently denied. Please enable them in your app settings.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _initialLocation = LatLng(position.latitude, position.longitude);
        _updateMarkers();
        _isLoading = false;
      });

      // Get the name of the current location
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _startLocName =
              "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
        });
      }

      if (_isMapReady) {
        _mapController.move(_initialLocation!, 15.0);
      }
    } catch (e) {
      String errorMessage = e.toString().split(': ').last;
      ToasterService.error(message: 'Error getting location: $errorMessage');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchLocation(String searchQuery) async {
    try {
      if (!searchQuery.toLowerCase().contains('nepal')) {
        searchQuery += ', Nepal';
      }

      List<Location> locations = await locationFromAddress(searchQuery);

      if (locations.isNotEmpty) {
        Location firstLocation = locations.first;
        LatLng newLocation =
            LatLng(firstLocation.latitude, firstLocation.longitude);

        // Check if the location is within Nepal bounds
        if (_nepalBounds.contains(newLocation)) {
          setState(() {
            _destinationLocation = newLocation;
            _searchAddress = searchQuery;
            _endLocName = searchQuery; // Store the end location name
            _updateMarkers();
          });

          _fitMapToMarkers();

          // Get more detailed information about the end location
          List<Placemark> placemarks = await placemarkFromCoordinates(
              firstLocation.latitude, firstLocation.longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            setState(() {
              _endLocName =
                  "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
            });
          }
        } else {
          ToasterService.error(message: 'Location is outside of Nepal');
        }
      } else {
        ToasterService.error(
            message: 'No locations found for $searchQuery in Nepal');
      }
    } catch (e) {
      String errorMessage = e.toString().split(': ').last;
      ToasterService.error(message: 'Error searching location: $errorMessage');
    }
  }

  void _fitMapToMarkers() {
    if (_markers.isNotEmpty && _isMapReady) {
      double minLat = _markers.first.point.latitude;
      double maxLat = _markers.first.point.latitude;
      double minLong = _markers.first.point.longitude;
      double maxLong = _markers.first.point.longitude;

      for (var marker in _markers) {
        minLat = math.min(minLat, marker.point.latitude);
        maxLat = math.max(maxLat, marker.point.latitude);
        minLong = math.min(minLong, marker.point.longitude);
        maxLong = math.max(maxLong, marker.point.longitude);
      }

      double centerLat = (minLat + maxLat) / 2;
      double centerLong = (minLong + maxLong) / 2;
      double latDelta = (maxLat - minLat).abs();
      double longDelta = (maxLong - minLong).abs();

      // Calculate zoom level based on the bounding box
      double zoom = 11.0 - math.log(math.max(latDelta, longDelta)) / math.ln2;

      // Ensure the zoom level is within the allowed range
      zoom = zoom.clamp(6.0, 18.0);

      _mapController.move(LatLng(centerLat, centerLong), zoom);
    }
  }

  void _updateMarkers() {
    _markers.clear();
    if (_initialLocation != null) {
      _markers.add(_createMarker(_initialLocation!, 'Start', Colors.blue));
    }
    if (_destinationLocation != null) {
      _markers.add(_createMarker(
          _destinationLocation!, 'Final destination', Colors.red));
    }
    for (int i = 0; i < _waypoints.length; i++) {
      _markers.add(_createMarker(_waypoints[i]['location'],
          'Stop ${i + 1}: ${_waypoints[i]['name']}', Colors.green));
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = selectedDay;
        _endDate = null;
      } else if (_endDate == null && selectedDay.isAfter(_startDate!)) {
        _endDate = selectedDay;
      } else {
        _startDate = selectedDay;
        _endDate = null;
      }
      _focusedDay = focusedDay;
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _startDate = start;
      _endDate = end;
      _focusedDay = focusedDay;
    });
  }

  Widget _buildDateDisplay(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Texts(
          texts: date != null
              ? DateFormat('MMM dd, yyyy').format(date)
              : 'Not selected',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ],
    );
  }

  Marker _createMarker(LatLng point, String label, Color color) {
    return Marker(
      width: 120.0,
      height: 80.0,
      point: point,
      child: Column(
        children: [
          Icon(Icons.location_on, color: color, size: 40.0),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _addWaypoint(String waypointName) async {
    if (_destinationLocation == null) {
      ToasterService.error(message: 'Please set a final destination first.');
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(waypointName);
      if (locations.isNotEmpty) {
        Location firstLocation = locations.first;
        LatLng waypointLocation =
            LatLng(firstLocation.latitude, firstLocation.longitude);
        setState(() {
          _waypoints.add({
            'name': waypointName,
            'location': waypointLocation,
          });
          _updateMarkers();
          _fitMapToMarkers();
        });
      } else {
        ToasterService.error(message: 'No location found for $waypointName');
      }
    } catch (e) {
      String errorMessage = e.toString().split(': ').last;
      ToasterService.error(message: 'Error adding waypoint: $errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripPlannerCubit(PostTripApiService()),
      child: Scaffold(
        backgroundColor: AppColor.appColor,
        appBar: const kBar(),
        body: _isLoading
            ? Center(child: AppLoading())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 14, right: 6),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0.0, 2.0),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        hintText: 'Search for a location',
                                        border: InputBorder.none,
                                      ),
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          _searchLocation(value);
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.search,
                                        color: Colors.blue),
                                    onPressed: () {
                                      String searchQuery =
                                          _searchController.text.trim();
                                      if (searchQuery.isNotEmpty) {
                                        _searchLocation(searchQuery);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 450,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _nepalCenter,
                          initialZoom: 7.0, // Adjusted for better Nepal view
                          minZoom: 6.0,
                          maxZoom: 18.0,
                          onMapReady: () {
                            setState(() {
                              _isMapReady = true;
                            });
                            _fitMapToMarkers();
                          },
                        ),
                        children: [
                          _currentTileLayer,
                          MarkerLayer(markers: _markers),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: [
                                  if (_initialLocation != null)
                                    _initialLocation!,
                                  ..._waypoints.map((wp) => wp['location']),
                                  if (_destinationLocation != null)
                                    _destinationLocation!,
                                ],
                                color: Colors.blue,
                                strokeWidth: 4.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _waypointController,
                                decoration: const InputDecoration(
                                  hintText: 'Add Stops',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _addWaypoint(value);
                                    _waypointController.clear();
                                  }
                                },
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 104, 79, 163),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              ),
                              child: IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  String waypointName =
                                      _waypointController.text.trim();
                                  if (waypointName.isNotEmpty) {
                                    _addWaypoint(waypointName);
                                    _waypointController.clear();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _waypoints.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Map<String, dynamic> waypoint = entry.value;

                          List<Color> chipColors = [
                            const Color.fromARGB(255, 114, 168, 216), // Blue
                            const Color.fromARGB(255, 189, 89, 126), // Pink
                            const Color.fromARGB(255, 99, 156, 102), // Green
                            const Color.fromARGB(255, 216, 141, 83), // Orange
                            const Color.fromARGB(255, 132, 82, 133), // Purple
                            const Color.fromARGB(
                                255, 124, 90, 190), // Deep Purple
                            const Color.fromARGB(255, 109, 184, 194), // Cyan
                            const Color.fromARGB(255, 214, 176, 86), // Amber
                          ];

                          Color chipColor = chipColors[idx % chipColors.length];

                          return Chip(
                            label: Texts(
                              texts: 'Stop ${idx + 1}: ${waypoint['name']}',
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 5,
                            ),
                            backgroundColor: chipColor,
                            deleteIcon: const Icon(Icons.close, size: 18),
                            deleteIconColor: Colors.white.withOpacity(0.7),
                            onDeleted: () {
                              setState(() {
                                _waypoints.removeAt(idx);
                                _updateMarkers();
                                _fitMapToMarkers();
                              });
                            },
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              child: Texts(
                                texts: '${idx + 1}',
                                fontWeight: FontWeight.w500,
                                fontSize: 5,
                                color: Colors.white,
                              ),
                            ),
                            elevation: 3,
                            shadowColor: chipColor.withOpacity(0.4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildElegantCalendar(),
                    const SizedBox(height: 16),
                    Containers(
                      margin: const EdgeInsets.symmetric(horizontal: 22.0),
                      width: maxWidth(context),
                      child: const Texts(
                        texts: 'Select means of transportation',
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildTransportationIcons(),
                    const SizedBox(height: 16),
                    _buildTripDetailsRow(),
                    const SizedBox(height: 16),
                    _buildBudgetTextField(),
                    const SizedBox(height: 16),
                    _buildCommentsTextField(),
                    const SizedBox(height: 26),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      child: BlocConsumer<TripPlannerCubit, TripPlannerState>(
                        listener: (context, state) {
                          if (state is TripPlannerSuccess) {
                            _clearForm();

                            if (context.mounted) {
                              Get.offAll(() => const BottomNavigationScreen());
                            }
                            ToasterService.success(
                                message: 'Trip planned successfully!');
                          } else if (state is TripPlannerFailure) {
                            ToasterService.error(message: state.error);
                          }
                        },
                        builder: (context, state) {
                          return AppBtn(
                            child: state is TripPlannerLoading
                                ? loading()
                                : btnText("Let's go"),
                            onTap: () {
                              if (state is! TripPlannerLoading) {
                                Trip trip = _createTripFromState();
                                context.read<TripPlannerCubit>().planTrip(trip);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 26),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBudgetTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: _buildTextField(
          _budgetController, 'Estimated Budget / person', Icons.attach_money),
    );
  }

  Widget _buildCommentsTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: TextField(
          controller: _commentsController,
          decoration: const InputDecoration(
            hintText: 'Ittenaries',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            prefixIcon: Icon(Icons.comment, color: Colors.blue),
          ),
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _buildElegantCalendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Texts(
              texts: 'Select Trip Dates',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            calendarFormat: CalendarFormat.month,
            rangeStartDay: _startDate,
            rangeEndDay: _endDate,
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) =>
                isSameDay(_startDate, day) || isSameDay(_endDate, day),
            onRangeSelected: _onRangeSelected,
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Colors.blue.withOpacity(0.2),
              rangeStartDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              withinRangeTextStyle: const TextStyle(color: Colors.blue),
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateDisplay('Start Date', _startDate),
                _buildDateDisplay('End Date', _endDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportationIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTransportIcon(Icons.motorcycle, Colors.red, 'Motorbike'),
          _buildTransportIcon(Icons.directions_car, Colors.blue, 'Car'),
          _buildTransportIcon(Icons.flight, Colors.green, 'Plane'),
          _buildTransportIcon(Icons.directions_bus, Colors.orange, 'Bus'),
        ],
      ),
    );
  }

  Widget _buildTransportIcon(IconData icon, Color color, String label) {
    bool isSelected = _selectedTransport == label;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedTransport = isSelected ? null : label;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border:
                  Border.all(color: isSelected ? color : Colors.grey, width: 2),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 4),
        Texts(
            texts: label,
            fontSize: 12,
            color: isSelected ? color : Colors.black)
      ],
    );
  }

  Widget _buildTripDetailsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(
                _numberOfPeopleController, 'No. of People', Icons.people),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTextField(
                _totalDaysController, 'Total Days', Icons.calendar_today),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _tripNameController.clear();
      _searchController.clear();
      _waypointController.clear();
      _numberOfPeopleController.clear();
      _totalDaysController.clear();
      _budgetController.clear();
      _commentsController.clear();
      _initialLocation = null;
      _destinationLocation = null;
      _waypoints.clear();
      _startDate = null;
      _endDate = null;
      _selectedTransport = null;
      _updateMarkers();
    });
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          prefixIcon: Icon(icon, color: Colors.blue),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
