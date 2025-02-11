class UserResponse {
  late num id;
  late String name;
  late String email;
  late String? avatarUrl;
  late String role;
  late String createdAt;
  late String? modifiedAt;
  late String status;
  late String? deviceToken;
  late bool notificationOn;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    required this.createdAt,
    required this.modifiedAt,
    required this.status,
    required this.deviceToken,
    required this.notificationOn
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
      deviceToken: map['deviceToken'],
      notificationOn: map['notificationOn']
    );
  }

  static Map<String, dynamic> toMap(UserResponse data) {
    return {
      'id': data.id,
      'name': data.name,
      'email': data.email,
      'avatarUrl': data.avatarUrl,
      'role': data.role,
      'createdAt': data.createdAt,
      'modifiedAt': data.modifiedAt,
      'status': data.status,
      'deviceToken': data.deviceToken,
      'notificationOn': data.notificationOn
    };
  }

  static UserResponse empty() {
    return UserResponse(
        id: 0,
        name: '',
        email: '',
        avatarUrl: '',
        role: '',
        createdAt: '',
        modifiedAt: '',
        status: '',
        deviceToken: '',
        notificationOn: true
    );
  }
}