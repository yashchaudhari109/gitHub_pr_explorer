import 'package:equatable/equatable.dart';
import 'package:github_pr_explorer/features/pull_requests/bloc/pull_requests_bloc.dart';

abstract class PullRequestsEvent extends Equatable {
  const PullRequestsEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch PRs, using the owner/repo currently in the state.
class PullRequestsFetched extends PullRequestsEvent {}

/// Event to refresh PRs, using the owner/repo currently in the state.
class PullRequestsRefreshed extends PullRequestsEvent {}

/// Event dispatched when the user changes the repo and triggers a fetch.
class PullRequestsRepoChanged extends PullRequestsEvent {
  final String owner;
  final String repo;
  final PullRequestStatus status;

  const PullRequestsRepoChanged({
    required this.owner,
    required this.repo,
    required this.status,
  });
  @override
  List<Object> get props => [owner, repo, status];
}
