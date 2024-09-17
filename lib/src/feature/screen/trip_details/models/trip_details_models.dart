// class TripDetailsModels {
//   bool? success;
//   int? status;
//   String? message;
//   Data? data;

//   TripDetailsModels({this.success, this.status, this.message, this.data});

//   TripDetailsModels.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   int? id;
//   int? userId;
//   String? tripName;
//   String? tripDescription;
//   String? startDate;
//   String? endDate;
//   String? arrivalTime;
//   String? tripPrice;
//   String? meansOfTransport;
//   bool? isPrivate;
//   String? createdAt;
//   String? updatedAt;

//   Data(
//       {this.id,
//       this.userId,
//       this.tripName,
//       this.tripDescription,
//       this.startDate,
//       this.endDate,
//       this.arrivalTime,
//       this.tripPrice,
//       this.meansOfTransport,
//       this.isPrivate,
//       this.createdAt,
//       this.updatedAt});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     tripName = json['trip_name'];
//     tripDescription = json['trip_description'];
//     startDate = json['start_date'];
//     endDate = json['end_date'];
//     arrivalTime = json['arrival_time'];
//     tripPrice = json['trip_price'];
//     meansOfTransport = json['means_of_transport'];
//     isPrivate = json['is_private'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['trip_name'] = tripName;
//     data['trip_description'] = tripDescription;
//     data['start_date'] = startDate;
//     data['end_date'] = endDate;
//     data['arrival_time'] = arrivalTime;
//     data['trip_price'] = tripPrice;
//     data['means_of_transport'] = meansOfTransport;
//     data['is_private'] = isPrivate;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }

// Define the TripDetailsModels class
class TripDetailsModels {
  final bool success;
  final int status;
  final String message;
  final TripData data;

  TripDetailsModels({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  // Factory method to create a TripDetailsModels instance from JSON
  factory TripDetailsModels.fromJson(Map<String, dynamic> json) {
    return TripDetailsModels(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: TripData.fromJson(json['data']),
    );
  }

  // Method to convert TripDetailsModels instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Define the TripData class
class TripData {
  final Trip trip;
  final bool isEnrolled;

  TripData({
    required this.trip,
    required this.isEnrolled,
  });

  // Factory method to create a TripData instance from JSON
  factory TripData.fromJson(Map<String, dynamic> json) {
    return TripData(
      trip: Trip.fromJson(json['trip']),
      isEnrolled: json['isEnrolled'],
    );
  }

  // Method to convert TripData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'trip': trip.toJson(),
      'isEnrolled': isEnrolled,
    };
  }
}

// Define the Trip class
class Trip {
  final int id;
  final int userId;
  final String tripName;
  final String tripDescription;
  final String startDate;
  final String endDate;
  final String arrivalTime;
  final String tripPrice;
  final String meansOfTransport;
  final bool isPrivate;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> users;

  Trip({
    required this.id,
    required this.userId,
    required this.tripName,
    required this.tripDescription,
    required this.startDate,
    required this.endDate,
    required this.arrivalTime,
    required this.tripPrice,
    required this.meansOfTransport,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
  });

  // Factory method to create a Trip instance from JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['user_id'],
      tripName: json['trip_name'],
      tripDescription: json['trip_description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      arrivalTime: json['arrival_time'],
      tripPrice: json['trip_price'],
      meansOfTransport: json['means_of_transport'],
      isPrivate: json['is_private'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      users: List<dynamic>.from(json['users']),
    );
  }

  // Method to convert Trip instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'trip_name': tripName,
      'trip_description': tripDescription,
      'start_date': startDate,
      'end_date': endDate,
      'arrival_time': arrivalTime,
      'trip_price': tripPrice,
      'means_of_transport': meansOfTransport,
      'is_private': isPrivate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'users': users,
    };
  }
}
