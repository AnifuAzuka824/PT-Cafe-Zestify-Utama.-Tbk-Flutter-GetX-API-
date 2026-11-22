class UserModel {
  final String nama;
  final String email;
  final String passwordHash;

  const UserModel({
    required this.nama,
    required this.email,
    required this.passwordHash,
  });

  String get namaPanggilan => nama.isNotEmpty ? nama.split(' ').first : email.split('@').first;

  Map<String, dynamic> toJson() => {
        'name': nama,
        'email': email,
        'pass': passwordHash,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        nama: json['name'] as String,
        email: json['email'] as String,
        passwordHash: json['pass'] as String,
      );
}
