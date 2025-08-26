import 'package:equatable/equatable.dart';

enum PullRequestDisplayStatus {
  open,
  draft,
  merged,
  closed, // This will represent closed but not merged
}

/// Represents the data structure for a GitHub pull request.
class PullRequestModel extends Equatable {
  final int id;
  final String title;
  final String? body;
  final DateTime createdAt;
  final UserModel user;
  final String htmlUrl;
  final PullRequestDisplayStatus prStatus;

  const PullRequestModel({
    required this.id,
    required this.title,
    this.body,
    required this.createdAt,
    required this.user,
    required this.htmlUrl,
    required this.prStatus,
  });

  /// Factory constructor to create a [PullRequestModel] from a JSON map.
  factory PullRequestModel.fromJson(Map<String, dynamic> json) {
    PullRequestDisplayStatus determinedStatus;

    final String state = json['state'] as String;
    final bool isDraft =
        json['draft'] as bool? ??
        false; // Safely handle if 'draft' key is missing
    final bool isMerged = json['merged_at'] != null;

    if (state == 'closed') {
      if (isMerged) {
        determinedStatus = PullRequestDisplayStatus.merged;
      } else {
        determinedStatus = PullRequestDisplayStatus.closed;
      }
    } else {
      if (isDraft) {
        determinedStatus = PullRequestDisplayStatus.draft;
      } else {
        determinedStatus = PullRequestDisplayStatus.open;
      }
    }
    return PullRequestModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      htmlUrl: json['html_url'] as String,
      prStatus: determinedStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    createdAt,
    user,
    htmlUrl,
    prStatus,
  ];
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
