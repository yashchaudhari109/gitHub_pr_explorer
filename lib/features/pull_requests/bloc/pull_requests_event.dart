import 'package:equatable/equatable.dart';

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

  const PullRequestsRepoChanged({required this.owner, required this.repo});

  @override
  List<Object> get props => [owner, repo];
}
