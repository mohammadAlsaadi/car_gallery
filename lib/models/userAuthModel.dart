// ignore_for_file: file_names

class UserAuth {
  String? uid; // Add uid field here
  String? email;
  String? password;
  String? name;

  UserAuth({
    required this.uid, // Include uid in the constructor
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid, // Include uid in the JSON representation
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      uid: json['uid'], // Parse uid from JSON
      email: json['email'],
      password: json['password'],
      name: json['name'],
    );
  }
}
