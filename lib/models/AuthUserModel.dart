class AuthUserModel {
  final int id;
  final String role;
  final String nama_lengkap;
  final String email;
  final String access_token;
  final String nik;
  final String no_kk;
  final String avatar;
  final String? fcm_token;
  AuthUserModel({
    required this.id,
    required this.nama_lengkap,
    required this.email,
    required this.access_token,
    required this.role,
    required this.nik,
    required this.no_kk,
    required this.fcm_token,
    this.avatar = '',
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'],
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      nama_lengkap: json['masyarakat']['nama_lengkap'] ?? '',
      nik: json['masyarakat']['nik'] ?? '',
      no_kk: json['masyarakat']['no_kk'] ?? '',
      access_token: json['access_token'] ?? '',
      avatar: json['avatar'] ?? '',
      fcm_token: json['fcm_token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'nama_lengkap': nama_lengkap,
      'nik': nik,
      'no_kk': no_kk,
      'access_token': access_token,
      'avatar': avatar,
      'fcm_token': fcm_token
    };
  }
}
