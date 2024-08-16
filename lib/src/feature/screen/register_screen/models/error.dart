class ErrorResponse {
  final String message;
  final Map<String, List<String>> errors;

  ErrorResponse({required this.message, required this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'] ?? 'An unexpected error occurred',
      errors: (json['errors'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }

  @override
  String toString() {
    return 'Message: $message, Errors: ${errors.isNotEmpty ? errors.values.expand((messages) => messages).join(', ') : 'None'}';
  }
}
