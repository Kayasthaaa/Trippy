// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  final bool success;
  final int status;
  final String message;
  final UserData data;

  RegisterResponse({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
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

  @override
  List<Object?> get props => [
        success,
        status,
        message,
        data,
      ];
}

class UserData extends Equatable {
  final String name;
  final String username;
  final String email;
  final String contact;
  final String bio;
  final String updatedAt;
  final String createdAt;
  final int id;
  final String? address;

  UserData({
    required this.name,
    required this.username,
    required this.email,
    required this.contact,
    required this.bio,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    this.address,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      contact: json['contact'],
      bio: json['bio'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'contact': contact,
      'bio': bio,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
      'address': address,
    };
  }

  @override
  List<Object?> get props => [
        name,
        username,
        email,
        contact,
        bio,
        updatedAt,
        createdAt,
        id,
        address,
      ];
}
