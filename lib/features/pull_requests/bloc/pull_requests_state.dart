import 'package:equatable/equatable.dart';
import 'package:github_pr_explorer/features/pull_requests/data/models/pull_request_model.dart';

/// Enum to represent the specific type of error encountered.
enum PullRequestErrorType {
  repositoryNotFound,
  invalidInput, //for invalid inputs
  rateLimitExceeded,
  unknown,
}

abstract class PullRequestsState extends Equatable {
  final String owner;
  final String repo;

  const PullRequestsState({required this.owner, required this.repo});

  @override
  List<Object> get props => [owner, repo];
}

class PullRequestsInitial extends PullRequestsState {
  const PullRequestsInitial({required super.owner, required super.repo});
}

class PullRequestsLoading extends PullRequestsState {
  const PullRequestsLoading({required super.owner, required super.repo});
}

class PullRequestsLoaded extends PullRequestsState {
  final List<PullRequestModel> pullRequests;

  const PullRequestsLoaded({
    required this.pullRequests,
    required super.owner,
    required super.repo,
  });

  @override
  List<Object> get props => [pullRequests, owner, repo];
}

class PullRequestsError extends PullRequestsState {
  final String message;
  final PullRequestErrorType type;

  const PullRequestsError({
    required this.message,
    required this.type,
    required super.owner,
    required super.repo,
  });

  @override
  List<Object> get props => [message, type, owner, repo];
}
