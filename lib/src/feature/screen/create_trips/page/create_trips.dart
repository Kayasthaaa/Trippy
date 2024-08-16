import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trippy/src/constant/toaster.dart';
import 'package:trippy/src/feature/widgets/app_texts.dart';
import 'package:trippy/src/feature/widgets/containers.dart';

class TripPlannerPage extends StatefulWidget {
  const TripPlannerPage({Key? key}) : super(key: key);

  @override
  _TripPlannerPageState createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage> {
  late MapController _mapController;
  final List<Marker> _markers = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _waypointController = TextEditingController();
  String _searchAddress = '';
  LatLng? _initialLocation;
  LatLng? _destinationLocation;
  List<Map<String, dynamic>> _waypoints = [];

  TileLayer _currentTileLayer = TileLayer(
    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    subdomains: const ['a', 'b', 'c'],
  );

  bool _isLoading = true;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _checkLocationPermissionAndGetLocation();
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
        _destinationLocation =
            LatLng(firstLocation.latitude, firstLocation.longitude);

        setState(() {
          _searchAddress = searchQuery;
          _updateMarkers();
        });

        _fitMapToMarkers();
      } else {
        ToasterService.error(message: 'No locations found for $searchQuery');
      }
    } catch (e) {
      String errorMessage = e.toString().split(': ').last;
      ToasterService.error(message: 'Error searching location: $errorMessage');
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

      double zoom = 11.0 - math.log(math.max(latDelta, longDelta)) / math.ln2;

      _mapController.move(LatLng(centerLat, centerLong), zoom);
    }
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
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Trip Planner',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.blue),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for a destination',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
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
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _searchLocation(value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    height: 450,
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter:
                            _initialLocation ?? const LatLng(28.3949, 84.1240),
                        initialZoom: _initialLocation != null ? 15.0 : 8.0,
                        onMapReady: () {
                          setState(() {
                            _isMapReady = true;
                          });
                          if (_initialLocation != null) {
                            _mapController.move(_initialLocation!, 15.0);
                          }
                        },
                      ),
                      children: [
                        _currentTileLayer,
                        MarkerLayer(markers: _markers),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [
                                if (_initialLocation != null) _initialLocation!,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _waypointController,
                              decoration: const InputDecoration(
                                hintText: 'Add waypoint',
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
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.blue),
                            onPressed: () {
                              String waypointName =
                                  _waypointController.text.trim();
                              if (waypointName.isNotEmpty) {
                                _addWaypoint(waypointName);
                                _waypointController.clear();
                              }
                            },
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
                        return Chip(
                          label: Text('Stop ${idx + 1}: ${waypoint['name']}'),
                          backgroundColor: Colors.blue.shade100,
                          labelStyle: const TextStyle(color: Colors.black87),
                          deleteIconColor: Colors.red,
                          onDeleted: () {
                            setState(() {
                              _waypoints.removeAt(idx);
                              _updateMarkers();
                              _fitMapToMarkers();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
