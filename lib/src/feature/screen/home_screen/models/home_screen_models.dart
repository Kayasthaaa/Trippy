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
  Meta? meta;

  Data({this.trips, this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['trips'] != null) {
      trips = <Trips>[];
      json['trips'].forEach((v) {
        trips!.add(Trips.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trips != null) {
      data['trips'] = trips!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class Trips {
  int? id;
  int? userId;
  String? tripName;
  String? tripDescription;
  String? startDate;
  String? endDate;
  String? arrivalTime;
  String? tripPrice;
  String? meansOfTransport;
  bool? isPrivate;
  String? createdAt;
  String? updatedAt;

  Trips(
      {this.id,
      this.userId,
      this.tripName,
      this.tripDescription,
      this.startDate,
      this.endDate,
      this.arrivalTime,
      this.tripPrice,
      this.meansOfTransport,
      this.isPrivate,
      this.createdAt,
      this.updatedAt});

  Trips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    tripName = json['trip_name'];
    tripDescription = json['trip_description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    arrivalTime = json['arrival_time'];
    tripPrice = json['trip_price'];
    meansOfTransport = json['means_of_transport'];
    isPrivate = json['is_private'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['trip_name'] = tripName;
    data['trip_description'] = tripDescription;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['arrival_time'] = arrivalTime;
    data['trip_price'] = tripPrice;
    data['means_of_transport'] = meansOfTransport;
    data['is_private'] = isPrivate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Meta({this.total, this.perPage, this.currentPage, this.lastPage});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    return data;
  }
}
