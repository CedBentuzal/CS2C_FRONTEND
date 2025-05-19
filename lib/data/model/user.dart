class User {
  final String id;
  final String username;
  final String email;
  final String? profilePic; // Keep as nullable

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}