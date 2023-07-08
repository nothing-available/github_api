import 'dart:convert';

class RepoCommit {
  String sha;
  String author;
  String message;

  RepoCommit({
    required this.sha,
    required this.author,
    required this.message,
  });

  factory RepoCommit.fromJson(Map<String, dynamic> json) {
    return RepoCommit(
      sha: json['sha'],
      author: json['author']['login'],
      message: json['message'],
    );
  }
}
