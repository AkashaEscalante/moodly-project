class AppUser {
  final String id;
  final String email;
  final String fullName;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'] as String,
    email: json['email'] as String,
    fullName: json['full_name'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'full_name': fullName,
  };
}
