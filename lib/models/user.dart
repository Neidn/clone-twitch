import 'dart:convert';

class User {
  final String uid;
  final String username;
  final String email;

  User({
    required this.uid,
    required this.username,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
      );

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'username': username,
        'email': email,
      };
}
