class UserResponse {
  late String id;
  late String name;
  late String email;
  late String? avatarUrl;
  late String role;
  late String createdAt;
  late String? modifiedAt;
  late String status;
  late String? deviceToken;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    required this.createdAt,
    required this.modifiedAt,
    required this.status,
    required this.deviceToken
  });

  static UserResponse fromMap(Map<String, dynamic> map) {
    return UserResponse(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      role: map['role'],
      createdAt: map['createdAt'],
      modifiedAt: map['modifiedAt'],
      status: map['status'],
      deviceToken: map['deviceToken']
    );
  }
}