// ignore_for_file: unnecessary_question_mark

class CreatedTripDetailsModels {
  bool? success;
  int? status;
  String? message;
  Data? data;

  CreatedTripDetailsModels(
      {this.success, this.status, this.message, this.data});

  CreatedTripDetailsModels.fromJson(Map<String, dynamic> json) {
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
  Trip? trip;
  bool? isEnrolled;

  Data({this.trip, this.isEnrolled});

  Data.fromJson(Map<String, dynamic> json) {
    trip = json['trip'] != null ? Trip.fromJson(json['trip']) : null;
    isEnrolled = json['is_enrolled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trip != null) {
      data['trip'] = trip!.toJson();
    }
    data['is_enrolled'] = isEnrolled;
    return data;
  }
}

class Trip {
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
  List<Users>? users;
  TripLocation? tripLocation;
  List<StopOvers>? stopOvers;

  Trip(
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
      this.users,
      this.tripLocation,
      this.stopOvers});

  Trip.fromJson(Map<String, dynamic> json) {
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
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    tripLocation = json['trip_location'] != null
        ? TripLocation.fromJson(json['trip_location'])
        : null;
    if (json['stop_overs'] != null) {
      stopOvers = <StopOvers>[];
      json['stop_overs'].forEach((v) {
        stopOvers!.add(StopOvers.fromJson(v));
      });
    }
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
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (tripLocation != null) {
      data['trip_location'] = tripLocation!.toJson();
    }
    if (stopOvers != null) {
      data['stop_overs'] = stopOvers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? username;
  String? email;
  Null? emailVerifiedAt;
  String? contact;
  String? bio;
  Null? address;
  String? createdAt;
  String? updatedAt;
  int? laravelThroughKey;

  Users(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.emailVerifiedAt,
      this.contact,
      this.bio,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.laravelThroughKey});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    contact = json['contact'];
    bio = json['bio'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    laravelThroughKey = json['laravel_through_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['contact'] = contact;
    data['bio'] = bio;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['laravel_through_key'] = laravelThroughKey;
    return data;
  }
}

class TripLocation {
  int? id;
  int? tripId;
  String? startLoc;
  String? startLocName;
  String? endLoc;
  String? endLocName;
  String? createdAt;
  String? updatedAt;

  TripLocation(
      {this.id,
      this.tripId,
      this.startLoc,
      this.startLocName,
      this.endLoc,
      this.endLocName,
      this.createdAt,
      this.updatedAt});

  TripLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    startLoc = json['start_loc'];
    startLocName = json['start_loc_name'];
    endLoc = json['end_loc'];
    endLocName = json['end_loc_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trip_id'] = tripId;
    data['start_loc'] = startLoc;
    data['start_loc_name'] = startLocName;
    data['end_loc'] = endLoc;
    data['end_loc_name'] = endLocName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class StopOvers {
  int? id;
  int? tripId;
  String? location;
  String? createdAt;
  String? updatedAt;

  StopOvers(
      {this.id, this.tripId, this.location, this.createdAt, this.updatedAt});

  StopOvers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trip_id'] = tripId;
    data['location'] = location;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
