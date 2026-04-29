class Profile {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? sexo;
  final DateTime? fechaNacimiento;
  final String? ciudad;

  const Profile({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.sexo,
    this.fechaNacimiento,
    this.ciudad,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as String,
    fullName: (json['full_name'] as String?) ?? '',
    email: (json['email'] as String?) ?? '',
    avatarUrl: json['avatar_url'] as String?,
    bio: json['bio'] as String?,
    sexo: json['sexo'] as String?,
    fechaNacimiento: json['fecha_nacimiento'] != null
        ? DateTime.tryParse(json['fecha_nacimiento'] as String)
        : null,
    ciudad: json['ciudad'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'avatar_url': avatarUrl,
    'bio': bio,
    'sexo': sexo,
    'fecha_nacimiento': fechaNacimiento?.toIso8601String().split('T')[0],
    'ciudad': ciudad,
  };

  Profile copyWith({
    String? fullName,
    String? email,
    String? avatarUrl,
    String? bio,
    String? sexo,
    DateTime? fechaNacimiento,
    bool clearFechaNacimiento = false,
    String? ciudad,
  }) =>
      Profile(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        sexo: sexo ?? this.sexo,
        fechaNacimiento:
            clearFechaNacimiento ? null : (fechaNacimiento ?? this.fechaNacimiento),
        ciudad: ciudad ?? this.ciudad,
      );
}
