class HomeModel {
  bool? success;
  int? status;
  String? message;
  Data? data;

  HomeModel({this.success, this.status, this.message, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Trips>? trips;

  Data({this.trips});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['trips'] != null) {
      trips = <Trips>[];
      json['trips'].forEach((v) {
        trips!.add(Trips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trips != null) {
      data['trips'] = trips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trips {
  int? id;
  int? userId;
  String? tripType;
  String? tripName;
  String? tripDescription;
  String? startDate;
  String? endDate;
  int? numberOfDays;
  String? tripPrice;
  String? totalPeople;
  String? meansOfTransport;
  bool? isPrivate;
  String? createdAt;
  String? updatedAt;
  bool? isEnrolled;

  Trips(
      {this.id,
      this.userId,
      this.tripType,
      this.tripName,
      this.tripDescription,
      this.startDate,
      this.endDate,
      this.numberOfDays,
      this.tripPrice,
      this.totalPeople,
      this.meansOfTransport,
      this.isPrivate,
      this.createdAt,
      this.updatedAt,
      this.isEnrolled});

  Trips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    tripType = json['trip_type'];
    tripName = json['trip_name'];
    tripDescription = json['trip_description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    numberOfDays = json['number_of_days'];
    tripPrice = json['trip_price'];
    totalPeople = json['total_people'];
    meansOfTransport = json['means_of_transport'];
    isPrivate = json['is_private'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isEnrolled = json['is_enrolled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['trip_type'] = tripType;
    data['trip_name'] = tripName;
    data['trip_description'] = tripDescription;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['number_of_days'] = numberOfDays;
    data['trip_price'] = tripPrice;
    data['total_people'] = totalPeople;
    data['means_of_transport'] = meansOfTransport;
    data['is_private'] = isPrivate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_enrolled'] = isEnrolled;
    return data;
  }
}
