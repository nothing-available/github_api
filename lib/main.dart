import 'package:flutter/material.dart';
import 'package:github_api/models/commits.dart';
import 'package:github_api/models/repo.dart';
import 'package:github_api/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}
// Function to fetch user data from the GitHub API
Future<User> fetchUser() async {
  final response = await http.get(Uri.parse("https://api.github.com/users/freeCodeCamp"));

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
     throw Exception('Failed to fetch user!');
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<User> futureUser;
  late Future<List<Repo>> futureRepos;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    futureRepos = fetchRepos();
  }

    // Function to fetch repository data from the GitHub API

  Future<List<Repo>> fetchRepos() async {
    final response = await http.get(Uri.parse("https://api.github.com/users/freeCodeCamp/repos"));

    if (response.statusCode == 200) {
      final List<dynamic> repoJson = json.decode(response.body);
      List<Repo> repos = [];

      for (var json in repoJson) {
        repos.add(
          Repo(
            name: json['name'],
            description: json['description'],
            htmlUrl: json['html_url'],
            stargazersCount: json['stargazers_count'],
          ),
        );
      }

      return repos;
    } else {
      throw Exception('Failed to fetch repos!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub API!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: FutureBuilder<List<Repo>>(
            future: futureRepos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                List<Repo> repos = snapshot.data!;
                List<Future<http.Response>> futures = [];

                for (var repo in repos) {
                  futures.add(
                    http.get(Uri.parse("https://api.github.com/repos/freeCodeCamp/1Aug2015GameDev/commits")),
                  );
                }

                return ListView.builder(
                  itemCount: repos.length,
                  itemBuilder: (context, index) {
                    Repo repo = repos[index];

                    return FutureBuilder<http.Response>(
                      future: futures[index],
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasError) {
                          return const SizedBox();
                        } else if (snapshot.hasData) {
                          List<dynamic> commitJson = json.decode(snapshot.data!.body);

                          if (commitJson.isNotEmpty) {
                            Map<String, dynamic> commitData = commitJson.first['commit'];
                            Commit commit = Commit.fromJson(commitData);

                            return Card(
                              color: const Color.fromARGB(255, 38, 55, 69),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          repo.name ?? '',
                                          style: const TextStyle(fontSize: 25.0, color: Colors.white),
                                        ),
                                        Text(
                                          repo.stargazersCount.toString(),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      repo.description ?? '',
                                      style: const TextStyle(fontSize: 20.0, color: Colors.white),
                                    ),
                                    Text(
                                      repo.htmlUrl ?? '',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Last Commit: ${commit.message}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}

// class User {
//   final String login;
//   final String name;

//   User({
//     required this.login,
//     required this.name,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       login: json['login'],
//       name: json['name'],
//     );
//   }
// }

// class Repo {
//   final String? name;
//   final String? description;
//   final String? htmlUrl;
//   final int? stargazersCount;

//   Repo({
//     this.name,
//     this.description,
//     this.htmlUrl,
//     this.stargazersCount,
//   });
// }

// class Commit {
//   final String? message;

//   Commit({
//     this.message,
//   });

//   factory Commit.fromJson(Map<String, dynamic> json) {
//     return Commit(
//       message: json['message'],
//     );
//   }
// }
