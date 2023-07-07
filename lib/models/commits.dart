class Commit {
  String sha;
  String message;

  Commit({
    required this.sha,
    required this.message,
  });

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
      sha: json['sha'],
      message: json['commit']['message'],
    );
  }
}