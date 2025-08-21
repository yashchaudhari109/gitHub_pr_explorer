import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_pr_explorer/core/di/injector.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_bloc.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_event.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_state.dart';
import 'package:github_pr_explorer/features/pull_requests/bloc/pull_requests_bloc.dart';
import 'package:github_pr_explorer/features/pull_requests/bloc/pull_requests_event.dart';
import 'package:github_pr_explorer/features/pull_requests/bloc/pull_requests_state.dart';
import 'package:github_pr_explorer/features/pull_requests/data/repository/pull_request_repository.dart';
import 'package:github_pr_explorer/features/pull_requests/view/widgets/pull_request_list_item.dart';
import 'package:shimmer/shimmer.dart';

class PullRequestsView extends StatelessWidget {
  const PullRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => PullRequestsBloc(
            pullRequestRepository: getIt<PullRequestRepository>(),
          )..add(PullRequestsFetched()),
      child: BlocBuilder<PullRequestsBloc, PullRequestsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${state.owner}/${state.repo}',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed:
                      () =>
                          _showEditRepoDialog(context, state.owner, state.repo),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 20),
                  onPressed:
                      () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                ),
              ],
            ),
            body: Column(
              children: [
                // Token display bar
                _buildTokenBar(context),
                Expanded(child: _buildPullRequestList(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditRepoDialog(
    BuildContext context,
    String currentOwner,
    String currentRepo,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => BlocProvider.value(
            value: BlocProvider.of<PullRequestsBloc>(context),
            child: _EditRepoDialog(
              currentOwner: currentOwner,
              currentRepo: currentRepo,
            ),
          ),
    );
  }

  Widget _buildTokenBar(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.blue.shade100,
            width: double.infinity,
            child: Text(
              'Logged in with token: ${authState.token}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPullRequestList(PullRequestsState state) {
    return Builder(
      builder: (context) {
        if (state is PullRequestsLoading || state is PullRequestsInitial) {
          return _buildLoadingShimmer();
        } else if (state is PullRequestsLoaded) {
          if (state.pullRequests.isEmpty) {
            return const Center(
              child: Text('No open pull requests found for this repository.'),
            );
          }
          return RefreshIndicator(
            onRefresh:
                () async => context.read<PullRequestsBloc>().add(
                  PullRequestsRefreshed(),
                ),
            child: ListView.builder(
              itemCount: state.pullRequests.length,
              itemBuilder:
                  (context, index) => PullRequestListItem(
                    pullRequest: state.pullRequests[index],
                  ),
            ),
          );
        } else if (state is PullRequestsError) {
          return _ErrorDisplay(state: state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder:
            (context, index) => Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4.0),
                    Container(width: 200.0, height: 12.0, color: Colors.white),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80.0,
                          height: 10.0,
                          color: Colors.white,
                        ),
                        Container(
                          width: 80.0,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

// --- Stateful Widget for the Dialog ---
class _EditRepoDialog extends StatefulWidget {
  final String currentOwner;
  final String currentRepo;

  const _EditRepoDialog({
    required this.currentOwner,
    required this.currentRepo,
  });

  @override
  State<_EditRepoDialog> createState() => _EditRepoDialogState();
}

class _EditRepoDialogState extends State<_EditRepoDialog> {
  late final TextEditingController _ownerController;
  late final TextEditingController _repoController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _ownerController = TextEditingController(text: widget.currentOwner);
    _repoController = TextEditingController(text: widget.currentRepo);
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _repoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Change Repository',
        style: TextStyle(fontSize: 14, height: 1.1),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 12, height: 1.1),
                controller: _ownerController,
                decoration: const InputDecoration(labelText: 'Owner'),
                validator:
                    (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Cannot be empty'
                            : null,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 12, height: 1.1),
                controller: _repoController,
                decoration: const InputDecoration(labelText: 'Repository Name'),
                validator:
                    (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Cannot be empty'
                            : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                context.read<PullRequestsBloc>().add(
                  const PullRequestsRepoChanged(
                    owner: 'yashchaudhari109',
                    repo: 'gitHub_pr_explorer',
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text(
                'Reset',
                style: TextStyle(fontSize: 12, height: 1.1),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 12, height: 1.1),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<PullRequestsBloc>().add(
                    PullRequestsRepoChanged(
                      owner: _ownerController.text.trim(),
                      repo: _repoController.text.trim(),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Search',
                style: TextStyle(fontSize: 12, height: 1.1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- Dedicated Widget for Error Display ---
class _ErrorDisplay extends StatelessWidget {
  final PullRequestsError state;
  const _ErrorDisplay({required this.state});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String title;
    final String message;

    switch (state.type) {
      case PullRequestErrorType.repositoryNotFound:
        icon = Icons.error_outline;
        title = 'Repository Not Found';
        message =
            'Could not find a public repository for "${state.owner}/${state.repo}". Check for typos or private repository status.';
        break;
      case PullRequestErrorType.rateLimitExceeded:
        icon = Icons.timer_off_outlined;
        title = 'API Rate Limit Exceeded';
        message =
            'You have made too many requests to the GitHub API. Please wait a while before trying again.';
        break;
      case PullRequestErrorType.invalidInput:
        icon = Icons.input;
        title = 'Invalid Input';
        message =
            'The owner or repository name you entered is not valid. Please correct it and try again.';
        break;
      case PullRequestErrorType.unknown:
        icon = Icons.wifi_off_outlined;
        title = 'An Error Occurred';
        message = state.message; // Display the message for network errors etc.
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.read<PullRequestsBloc>().add(
                      const PullRequestsRepoChanged(
                        owner: 'yashchaudhari109',
                        repo: 'gitHub_pr_explorer',
                      ),
                    );
                  },
                  child: const Text('Reset to Default'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed:
                      () => context.read<PullRequestsBloc>().add(
                        PullRequestsFetched(),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
