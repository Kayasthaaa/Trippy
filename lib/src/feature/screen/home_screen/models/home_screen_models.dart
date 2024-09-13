class HomeModel {
  final bool success;
  final int status;
  final String message;
  final Data data;

  HomeModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  final List<Trip> trips;
  final Meta meta;

  Data({
    required this.trips,
    required this.meta,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      trips: List<Trip>.from(json['trips'].map((x) => Trip.fromJson(x))),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trips': trips.map((x) => x.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class Trip {
  final int id;
  final int userId;
  final String tripName;
  final String tripDescription;
  final String startDate;
  final String endDate;
  final String arrivalPlace;
  final String arrivalDateTime;
  final bool isPrivate;
  final String tripPrice;
  final String createdAt;
  final String updatedAt;

  Trip({
    required this.id,
    required this.userId,
    required this.tripName,
    required this.tripDescription,
    required this.startDate,
    required this.endDate,
    required this.arrivalPlace,
    required this.arrivalDateTime,
    required this.isPrivate,
    required this.tripPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['user_id'],
      tripName: json['trip_name'],
      tripDescription: json['trip_description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      arrivalPlace: json['arrival_place'],
      arrivalDateTime: json['arrival_date_time'],
      isPrivate: json['is_private'],
      tripPrice: json['trip_price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'trip_name': tripName,
      'trip_description': tripDescription,
      'start_date': startDate,
      'end_date': endDate,
      'arrival_place': arrivalPlace,
      'arrival_date_time': arrivalDateTime,
      'is_private': isPrivate,
      'trip_price': tripPrice,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Meta {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  Meta({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }
}
