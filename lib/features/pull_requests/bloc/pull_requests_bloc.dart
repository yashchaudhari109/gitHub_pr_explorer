import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_pr_explorer/core/error/exceptions.dart';
import 'package:github_pr_explorer/features/pull_requests/bloc/pull_requests_event.dart';
import 'package:github_pr_explorer/features/pull_requests/bloc/pull_requests_state.dart';
import 'package:github_pr_explorer/features/pull_requests/data/repository/pull_request_repository.dart';

enum PullRequestStatus {
  // Define a string value for each member
  open('open'),
  closed('closed'),
  all('all');

  // Add a constant constructor and a final variable
  const PullRequestStatus(this.value);
  final String value;
}

class PullRequestsBloc extends Bloc<PullRequestsEvent, PullRequestsState> {
  final PullRequestRepository _pullRequestRepository;

  PullRequestsBloc({required PullRequestRepository pullRequestRepository})
    : _pullRequestRepository = pullRequestRepository,
      super(
        const PullRequestsInitial(
          owner: 'yashchaudhari109',
          repo: 'gitHub_pr_explorer',
          status: PullRequestStatus.all,
        ),
      ) {
    on<PullRequestsFetched>(_onPullRequestsFetched);
    on<PullRequestsRefreshed>(_onPullRequestsRefreshed);
    on<PullRequestsRepoChanged>(_onPullRequestsRepoChanged);
  }

  Future<void> _fetchData(
    String owner,
    String repo,
    PullRequestStatus status,
    Emitter<PullRequestsState> emit,
  ) async {
    try {
      final pullRequests = await _pullRequestRepository.getPullRequests(
        owner: owner,
        repo: repo,
        status: status,
      );
      emit(
        PullRequestsLoaded(
          pullRequests: pullRequests,
          owner: owner,
          repo: repo,
          status: status,
        ),
      );
    } on ServerException catch (e) {
      // Logic to determine the error type based on the status code
      final errorType = _mapStatusCodeToErrorType(e.statusCode);
      final message = e.message;
      emit(
        PullRequestsError(
          message: message,
          type: errorType,
          owner: owner,
          repo: repo,
          status: status,
        ),
      );
    }
  }

  PullRequestErrorType _mapStatusCodeToErrorType(int? statusCode) {
    switch (statusCode) {
      case 403:
        return PullRequestErrorType.rateLimitExceeded;
      case 404:
        return PullRequestErrorType.repositoryNotFound;
      case 422:
        return PullRequestErrorType.invalidInput;
      default:
        return PullRequestErrorType.unknown;
    }
  }

  Future<void> _onPullRequestsFetched(
    PullRequestsFetched event,
    Emitter<PullRequestsState> emit,
  ) async {
    emit(
      PullRequestsLoading(
        owner: state.owner,
        repo: state.repo,
        status: state.status,
      ),
    );
    await _fetchData(state.owner, state.repo, state.status, emit);
  }

  Future<void> _onPullRequestsRefreshed(
    PullRequestsRefreshed event,
    Emitter<PullRequestsState> emit,
  ) async {
    await _fetchData(state.owner, state.repo, state.status, emit);
  }

  Future<void> _onPullRequestsRepoChanged(
    PullRequestsRepoChanged event,
    Emitter<PullRequestsState> emit,
  ) async {
    // Basic validation for empty input
    if (event.owner.isEmpty || event.repo.isEmpty) {
      emit(
        PullRequestsError(
          message: 'Owner and Repository names cannot be empty.',
          type: PullRequestErrorType.invalidInput,
          owner: state.owner,
          repo: state.repo,
          status: state.status,
        ),
      );
      return;
    }
    emit(
      PullRequestsLoading(
        owner: event.owner,
        repo: event.repo,
        status: event.status,
      ),
    );
    await _fetchData(event.owner, event.repo, event.status, emit);
  }
}
