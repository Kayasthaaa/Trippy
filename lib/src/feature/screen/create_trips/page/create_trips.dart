import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TripPlannerPage extends StatefulWidget {
  @override
  _TripPlannerPageState createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage> {
  final Color primaryColor = Color.fromRGBO(0, 122, 255, 1);
  int selectedTransportation = -1;
  final List<String> transportImages = [
    'motorbike.png',
    'car.png',
    'bus.png',
    'plane.png'
  ];
  final List<Color> transportColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange
  ];
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<String> stopovers = [];
  final MapController mapController = MapController();
  List<Marker> mapMarkers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Text(
                    'Plan Your Nepal Adventure',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                FadeInUp(
                  delay: Duration(milliseconds: 200),
                  child: _buildInteractiveMap(),
                ),
                SizedBox(height: 32),
                FadeInLeft(
                  delay: Duration(milliseconds: 400),
                  child: _buildElegantTextField(
                      'Start Location', Icons.flight_takeoff,
                      onChanged: _addMarker),
                ),
                SizedBox(height: 16),
                FadeInRight(
                  delay: Duration(milliseconds: 600),
                  child: _buildElegantTextField(
                      'End Location', Icons.flight_land,
                      onChanged: _addMarker),
                ),
                SizedBox(height: 16),
                FadeInLeft(
                  delay: Duration(milliseconds: 800),
                  child: _buildStopoverSection(),
                ),
                SizedBox(height: 24),
                FadeInUp(
                  delay: Duration(milliseconds: 1000),
                  child: _buildElegantCalendar(),
                ),
                SizedBox(height: 24),
                FadeInUp(
                  delay: Duration(milliseconds: 1200),
                  child: Row(
                    children: [
                      Expanded(
                          child: _buildElegantTextField(
                              'Days', Icons.calendar_today)),
                      SizedBox(width: 16),
                      Expanded(
                          child:
                              _buildElegantTextField('People', Icons.person)),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                FadeInDown(
                  delay: Duration(milliseconds: 1400),
                  child: Text(
                    'Transportation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                FadeInUp(
                  delay: Duration(milliseconds: 1600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      transportImages.length,
                      (index) => _buildTransportationImage(index),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                FadeInUp(
                  delay: Duration(milliseconds: 1800),
                  child: _buildElegantTextField(
                      'Estimated Budget', Icons.attach_money),
                ),
                SizedBox(height: 32),
                FadeInUp(
                  delay: Duration(milliseconds: 2000),
                  child: _buildCommentsSection(),
                ),
                SizedBox(height: 48),
                FadeInUp(
                  delay: Duration(milliseconds: 2200),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        child: Text(
                          'Start Your Nepal Adventure',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveMap() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: LatLng(28.3949, 84.1240), // Center of Nepal
            initialZoom: 7,
            onTap: (tapPosition, point) {
              _addMarker(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(markers: mapMarkers),
          ],
        ),
      ),
    );
  }

  void _addMarker(dynamic location) {
    setState(() {
      if (location is LatLng) {
        mapMarkers.add(Marker(
          point: location,
          child: Icon(Icons.location_on, color: Colors.red, size: 30),
        ));
      } else if (location is String) {
        // This is a simplification. In a real app, you'd use a geocoding service to convert location names to coordinates.
        mapMarkers.add(Marker(
          point: LatLng(28.3949, 84.1240), // Example coordinates
          child: Icon(Icons.location_on, color: Colors.red, size: 30),
        ));
      }
    });
  }

  Widget _buildElegantTextField(String hint, IconData icon,
      {Function(String)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(icon, color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildStopoverSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stopovers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...stopovers.map((stopover) => _buildStopoverChip(stopover)),
            _buildAddStopoverButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildStopoverChip(String stopover) {
    final color =
        Colors.primaries[stopovers.indexOf(stopover) % Colors.primaries.length];
    return Chip(
      label: Text(stopover, style: TextStyle(color: Colors.white)),
      deleteIcon: Icon(Icons.close, color: Colors.white),
      onDeleted: () {
        setState(() {
          stopovers.remove(stopover);
        });
      },
      backgroundColor: color,
    );
  }

  Widget _buildAddStopoverButton() {
    return ActionChip(
      label: Text('Add Stopover'),
      avatar: Icon(Icons.add),
      onPressed: () async {
        final result = await showDialog<String>(
          context: context,
          builder: (context) => _buildAddStopoverDialog(),
        );
        if (result != null && result.isNotEmpty) {
          setState(() {
            stopovers.add(result);
          });
          _addMarker(result);
        }
      },
    );
  }

  Widget _buildAddStopoverDialog() {
    String newStopover = '';
    return AlertDialog(
      title: Text('Add Stopover'),
      content: TextField(
        onChanged: (value) => newStopover = value,
        decoration: InputDecoration(hintText: 'Enter stopover location'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(newStopover),
          child: Text('Add'),
        ),
      ],
    );
  }

  Widget _buildElegantCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        // onDaySelected: (selectedDay, focusedDay, _) {
        //   setState(() {
        //     _selectedDay = selectedDay;
        //     _focusedDay = focusedDay;
        //   });
        // },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }

  Widget _buildTransportationImage(int index) {
    bool isSelected = selectedTransportation == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransportation = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? transportColors[index].withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? transportColors[index]
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Image.asset(
          'assets/${transportImages[index]}',
          width: 40,
          height: 40,
          color: isSelected ? transportColors[index] : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add your comments or notes here...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
