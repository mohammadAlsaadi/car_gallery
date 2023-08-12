// ignore_for_file: file_names

class UserAuth {
  String uid;
  String email;
  String password;
  String name;
  String phoneNumber;

  UserAuth({
    required this.uid,
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      uid: json['uid'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
