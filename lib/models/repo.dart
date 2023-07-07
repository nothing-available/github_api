class Repo {
  String name;
  String htmlUrl; // hmtl_url
  String description;

  Repo({required this.name, required this.htmlUrl, required this.description});

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      htmlUrl: json['html_url'],
      description: json['description'],
    );
  }
}

class All {
  List<Repo> repos;

  All({required this.repos});

  factory All.fromJson(List<dynamic> json) {
    List<Repo> repos = <Repo>[];
    repos = json.map((r) => Repo.fromJson(r)).toList();
    return All(repos: repos);
  }
}