import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable {
  final bool success;
  final int status;
  final String message;
  final dynamic data;

  const ErrorModel({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  @override
  List<Object?> get props => [success, status, message, data];
}
