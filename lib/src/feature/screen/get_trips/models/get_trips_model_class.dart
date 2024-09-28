class TripResponse {
  bool? success;
  int? status;
  String? message;
  List<Data>? data;

  TripResponse({this.success, this.status, this.message, this.data});

  TripResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
