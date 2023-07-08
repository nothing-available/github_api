import 'dart:convert';

import 'package:github_api/models/commits.dart';


class Repo {
  String name;
  String description;
  String htmlUrl;
  int stargazersCount;
  RepoCommit? lastCommit;

  Repo({
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    this.lastCommit,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      description: json['description'],
      htmlUrl: json['html_url'],
      stargazersCount: json['stargazers_count'],
    );
  }
}
