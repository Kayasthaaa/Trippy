class GetProfileModels {
  final bool success;
  final int status;
  final String message;
  final List<UserData> data;

  GetProfileModels({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetProfileModels.fromJson(Map<String, dynamic> json) {
    return GetProfileModels(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => UserData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String username;
  final String email;
  final String contact;
  final String? bio;
  final String? address;

  UserData({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.contact,
    this.bio,
    this.address,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      bio: json['bio'], // Nullable
      address: json['address'], // Nullable
    );
  }
}
