class Trip {
  final String name;
  final String description;
  final String type; // Field for trip type
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final String meansOfTransport;
  final bool isPrivate;
  final String startLoc;
  final String startLocName;
  final String endLoc;
  final String endLocName;
  final String totalPeople; // Changed totalPeople to String
  final List<String> locations;

  Trip({
    required this.name,
    required this.description,
    required this.type, // Initialize trip type
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.meansOfTransport,
    required this.isPrivate,
    required this.startLoc,
    required this.startLocName,
    required this.endLoc,
    required this.endLocName,
    required this.totalPeople, // Initialize totalPeople as String
    required this.locations,
  });

  Map<String, dynamic> toJson() {
    return {
      'trip_name': name,
      'trip_description': description,
      'trip_type': type, // Include trip type
      'trip_price': price,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'means_of_transport': meansOfTransport,
      'is_private': isPrivate,
      'start_loc': startLoc,
      'start_loc_name': startLocName,
      'end_loc': endLoc,
      'end_loc_name': endLocName,
      'total_people': totalPeople, // Include totalPeople as String
      'location': locations,
    };
  }
}
