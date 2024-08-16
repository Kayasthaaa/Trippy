


// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:intl/intl.dart';
// import 'package:trippy/src/constant/colors.dart';
// import 'package:trippy/src/feature/widgets/app_btn.dart';
// import 'package:trippy/src/feature/widgets/app_texts.dart';
// import 'package:trippy/src/feature/widgets/no_menu_bar.dart';

// class TripPlannerPage extends StatefulWidget {
//   @override
//   _TripPlannerPageState createState() => _TripPlannerPageState();
// }

// class _TripPlannerPageState extends State<TripPlannerPage> {
//   final Color primaryColor = Color.fromRGBO(0, 122, 255, 1);
//   int selectedTransportation = -1;
//   final List<IconData> transportIcons = [
//     Icons.motorcycle,
//     Icons.directions_car,
//     Icons.directions_bus,
//     Icons.airplanemode_active
//   ];
//   final List<Color> transportColors = [
//     Colors.red,
//     Colors.blue,
//     Colors.green,
//     Colors.orange
//   ];
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _startDate;
//   DateTime? _endDate;
//   List<String> stopovers = [];
//   final MapController mapController = MapController();
//   List<Marker> mapMarkers = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appColor,
//       appBar: const kBar(),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 FadeInDown(
//                   child: Text(
//                     'Plan Your Nepal Adventure',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 FadeInUp(
//                   delay: Duration(milliseconds: 200),
//                   child: _buildInteractiveMap(),
//                 ),
//                 SizedBox(height: 32),
//                 FadeInLeft(
//                   delay: Duration(milliseconds: 400),
//                   child: _buildElegantTextField(
//                       'Start Location', Icons.flight_takeoff,
//                       onChanged: _addMarker),
//                 ),
//                 SizedBox(height: 16),
//                 FadeInRight(
//                   delay: Duration(milliseconds: 600),
//                   child: _buildElegantTextField(
//                       'End Location', Icons.flight_land,
//                       onChanged: _addMarker),
//                 ),
//                 SizedBox(height: 16),
//                 FadeInLeft(
//                   delay: Duration(milliseconds: 800),
//                   child: _buildStopoverSection(),
//                 ),
//                 SizedBox(height: 24),
//                 FadeInUp(
//                   delay: Duration(milliseconds: 1000),
//                   child: _buildElegantCalendar(),
//                 ),
//                 SizedBox(height: 24),
//                 FadeInUp(
//                   delay: Duration(milliseconds: 1200),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           child: _buildElegantTextField(
//                               'Days', Icons.calendar_today)),
//                       SizedBox(width: 16),
//                       Expanded(
//                           child:
//                               _buildElegantTextField('People', Icons.person)),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 FadeInDown(
//                   delay: Duration(milliseconds: 1400),
//                   child: Text(
//                     'Transportation',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 FadeInUp(
//                   delay: Duration(milliseconds: 1600),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: List.generate(
//                       transportIcons.length,
//                       (index) => _buildTransportationIcon(index),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 32),
//                 FadeInUp(
//                   delay: Duration(milliseconds: 1800),
//                   child: _buildElegantTextField(
//                       'Estimated Budget', Icons.attach_money),
//                 ),
//                 SizedBox(height: 32),
//                 FadeInUp(
//                   delay: Duration(milliseconds: 2000),
//                   child: _buildCommentsSection(),
//                 ),
//                 SizedBox(height: 48),
//                 FadeInUp(
//                     delay: Duration(milliseconds: 2200),
//                     child: AppBtn(
//                       child: Texts(
//                         texts: "Let's Go",
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInteractiveMap() {
//     return Container(
//       height: 300,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: FlutterMap(
//           mapController: mapController,
//           options: MapOptions(
//             initialCenter: LatLng(28.3949, 84.1240), // Center of Nepal
//             initialZoom: 7,
//             onTap: (tapPosition, point) {
//               _addMarker(point);
//             },
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//               subdomains: ['a', 'b', 'c'],
//             ),
//             MarkerLayer(markers: mapMarkers),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addMarker(dynamic location) {
//     setState(() {
//       if (location is LatLng) {
//         mapMarkers.add(Marker(
//           point: location,
//           child: Icon(Icons.location_on, color: Colors.red, size: 30),
//         ));
//       } else if (location is String) {
//         mapMarkers.add(Marker(
//           point: LatLng(28.3949, 84.1240), // Example coordinates
//           child: Icon(Icons.location_on, color: Colors.red, size: 30),
//         ));
//       }
//     });
//   }

//   Widget _buildElegantTextField(String hint, IconData icon,
//       {Function(String)? onChanged}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: TextField(
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           prefixIcon: Icon(icon, color: primaryColor),
//         ),
//       ),
//     );
//   }

//   Widget _buildStopoverSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Stopovers',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: [
//             ...stopovers.map((stopover) => _buildStopoverChip(stopover)),
//             _buildAddStopoverButton(),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStopoverChip(String stopover) {
//     final color =
//         Colors.primaries[stopovers.indexOf(stopover) % Colors.primaries.length];
//     return Chip(
//       label: Text(stopover, style: TextStyle(color: Colors.white)),
//       deleteIcon: Icon(Icons.close, color: Colors.white),
//       onDeleted: () {
//         setState(() {
//           stopovers.remove(stopover);
//         });
//       },
//       backgroundColor: color,
//     );
//   }

//   Widget _buildAddStopoverButton() {
//     return ActionChip(
//       label: Text('Add Stopover'),
//       avatar: Icon(Icons.add),
//       onPressed: () async {
//         final result = await showDialog<String>(
//           context: context,
//           builder: (context) => _buildAddStopoverDialog(),
//         );
//         if (result != null && result.isNotEmpty) {
//           setState(() {
//             stopovers.add(result);
//           });
//           _addMarker(result);
//         }
//       },
//     );
//   }

//   Widget _buildAddStopoverDialog() {
//     String newStopover = '';
//     return AlertDialog(
//       title: Text('Add Stopover'),
//       content: TextField(
//         onChanged: (value) => newStopover = value,
//         decoration: InputDecoration(hintText: 'Enter stopover location'),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () => Navigator.of(context).pop(newStopover),
//           child: Text('Add'),
//         ),
//       ],
//     );
//   }

//   Widget _buildElegantCalendar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Select Trip Dates',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: primaryColor,
//               ),
//             ),
//           ),
//           TableCalendar(
//             focusedDay: _focusedDay,
//             firstDay: DateTime.now(),
//             lastDay: DateTime.now().add(Duration(days: 365)),
//             calendarFormat: CalendarFormat.month,
//             rangeStartDay: _startDate,
//             rangeEndDay: _endDate,
//             rangeSelectionMode: RangeSelectionMode.toggledOn,
//             onDaySelected: _onDaySelected,
//             selectedDayPredicate: (day) =>
//                 isSameDay(_startDate, day) || isSameDay(_endDate, day),
//             onRangeSelected: _onRangeSelected,
//             calendarStyle: CalendarStyle(
//               rangeHighlightColor: primaryColor.withOpacity(0.2),
//               rangeStartDecoration: BoxDecoration(
//                 color: primaryColor,
//                 shape: BoxShape.circle,
//               ),
//               rangeEndDecoration: BoxDecoration(
//                 color: primaryColor,
//                 shape: BoxShape.circle,
//               ),
//               withinRangeTextStyle: TextStyle(color: primaryColor),
//               todayDecoration: BoxDecoration(
//                 color: primaryColor.withOpacity(0.5),
//                 shape: BoxShape.circle,
//               ),
//             ),
//             headerStyle: HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//               titleTextStyle: TextStyle(
//                 color: primaryColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildDateDisplay('Start Date', _startDate),
//                 _buildDateDisplay('End Date', _endDate),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       if (_startDate == null || (_startDate != null && _endDate != null)) {
//         _startDate = selectedDay;
//         _endDate = null;
//       } else if (_endDate == null && selectedDay.isAfter(_startDate!)) {
//         _endDate = selectedDay;
//       } else {
//         _startDate = selectedDay;
//         _endDate = null;
//       }
//       _focusedDay = focusedDay;
//     });
//   }

//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _startDate = start;
//       _endDate = end;
//       _focusedDay = focusedDay;
//     });
//   }

//   Widget _buildDateDisplay(String label, DateTime? date) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           date != null
//               ? DateFormat('MMM dd, yyyy').format(date)
//               : 'Not selected',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: primaryColor,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTransportationIcon(int index) {
//     final isSelected = selectedTransportation == index;
//     final color = isSelected ? transportColors[index] : Colors.grey;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedTransportation = index;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? color.withOpacity(0.1) : Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Icon(
//           transportIcons[index],
//           color: color,
//           size: 36,
//         ),
//       ),
//     );
//   }

//   Widget _buildCommentsSection() {
//     return _buildElegantTextField('Additional Comments', Icons.comment);
//   }
// }
