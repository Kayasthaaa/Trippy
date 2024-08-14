// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final bool success;
  final int status;
  final String message;
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final int userId;

  UserModel({
    required this.success,
    required this.status,
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'],
      status: json['status'],
      message: json['message'],
      accessToken: json['data']['access_token'],
      tokenType: json['data']['token_type'],
      expiresIn: json['data']['expires_in'],
      userId: json['data']['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'message': message,
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'user_id': userId,
    };
  }

  @override
  List<Object?> get props => [
        success,
        status,
        message,
        accessToken,
        tokenType,
        expiresIn,
        userId,
      ];
}
