import 'dart:convert';

class User {
  String login;
  String name;
  String avatarUrl;
  String bio;

  User({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
    );
  }
}
