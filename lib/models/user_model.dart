class AppUser {
  final int id;
  final String username;
  final String email;
  final String role;
  final String region;
  final String? avatarUrl;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.region,
    this.avatarUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      username: json['username'],
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      region: json['region'] ?? '',
      avatarUrl: json['avatar'],
    );
  }

  bool get isAdmin => role == 'admin';
}