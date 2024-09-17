class Trip {
  final String name;
  final String description;
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final String arrivalTime;
  final String meansOfTransport;
  final bool isPrivate;
  final String startLoc;
  final String startLocName;
  final String endLoc;
  final String endLocName;
  final List<String> locations;

  Trip({
    required this.name,
    required this.description,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.arrivalTime,
    required this.meansOfTransport,
    required this.isPrivate,
    required this.startLoc,
    required this.startLocName,
    required this.endLoc,
    required this.endLocName,
    required this.locations,
  });

  Map<String, dynamic> toJson() {
    return {
      'trip_name': name,
      'trip_description': description,
      'trip_price': price,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'arrival_time': arrivalTime,
      'means_of_transport': meansOfTransport,
      'is_private': isPrivate,
      'start_loc': startLoc,
      'start_loc_name': startLocName,
      'end_loc': endLoc,
      'end_loc_name': endLocName,
      'location': locations,
    };
  }
}
