class UserAuth {
  String? email;
  String? password;
  String? name;

  UserAuth({required this.email, required this.password, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      email: json['email'],
      password: json['password'],
      name: json['name'],
    );
  }
}
