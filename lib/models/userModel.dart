class UserModel {
  final int id;
  final String email;
  final String emailVerifiedAt;
  final String? fcmToken;
  final int status;
  final String avatar;
  final String nohp;
  final String role;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.emailVerifiedAt,
    this.fcmToken,
    required this.status,
    required this.nohp,
    required this.avatar,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'] ?? '',
      fcmToken: json['fcm_token'],
      status: json['status'] ?? 0,
      avatar: json['avatar'] ?? '',
      nohp: json['no_hp'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
