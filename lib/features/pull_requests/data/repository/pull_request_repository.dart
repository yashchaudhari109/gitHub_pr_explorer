import 'package:github_pr_explorer/core/api/api_client.dart';
import 'package:github_pr_explorer/core/error/exceptions.dart';
import 'package:github_pr_explorer/features/pull_requests/data/models/pull_request_model.dart';

// The contract for our repository. The PullRequestsBloc will depend on this.
abstract class PullRequestRepository {
  Future<List<PullRequestModel>> getOpenPullRequests({
    required String owner,
    required String repo,
  });
}

// The implementation that handles the data fetching and parsing logic.
class PullRequestRepositoryImpl implements PullRequestRepository {
  final ApiClient apiClient;

  PullRequestRepositoryImpl(this.apiClient);

  @override
  Future<List<PullRequestModel>> getOpenPullRequests({
    required String owner,
    required String repo,
  }) async {
    final uri = Uri.https('api.github.com', '/repos/$owner/$repo/pulls', {
      'state': 'open',
    });

    try {
      final responseData = await apiClient.get(uri);

      if (responseData is List) {
        final pullRequests =
            responseData
                .map(
                  (json) =>
                      PullRequestModel.fromJson(json as Map<String, dynamic>),
                )
                .toList();
        return pullRequests;
      } else {
        throw ServerException(message: 'Invalid response format from API');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'An unknown error occurred: $e');
    }
  }
}
