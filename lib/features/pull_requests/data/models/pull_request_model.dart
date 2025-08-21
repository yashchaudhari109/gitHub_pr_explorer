import 'package:equatable/equatable.dart';

/// Represents the data structure for a GitHub pull request.
class PullRequestModel extends Equatable {
  final int id;
  final String title;
  final String? body;
  final DateTime createdAt;
  final UserModel user;
  final String htmlUrl;

  const PullRequestModel({
    required this.id,
    required this.title,
    this.body,
    required this.createdAt,
    required this.user,
    required this.htmlUrl,
  });

  /// Factory constructor to create a [PullRequestModel] from a JSON map.
  factory PullRequestModel.fromJson(Map<String, dynamic> json) {
    return PullRequestModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      htmlUrl: json['html_url'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, user, htmlUrl];
}

/// Represents the author of the pull request.
class UserModel extends Equatable {
  final String login;

  const UserModel({required this.login});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(login: json['login'] as String);
  }

  @override
  List<Object> get props => [login];
}
