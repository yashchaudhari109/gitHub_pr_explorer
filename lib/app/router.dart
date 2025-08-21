import 'package:flutter/material.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_bloc.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_state.dart';
import 'package:github_pr_explorer/features/auth/view/login_view.dart';
import 'package:github_pr_explorer/features/pull_requests/data/models/pull_request_model.dart';
import 'package:github_pr_explorer/features/pull_requests/view/pull_request_detail_view.dart';
import 'package:github_pr_explorer/features/pull_requests/view/pull_requests_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: '/pull-requests',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(
        path: '/pull-requests',
        builder: (context, state) => const PullRequestsView(),
        routes: [
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final pullRequest = state.extra as PullRequestModel;
              return PullRequestDetailView(pullRequest: pullRequest);
            },
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state is AuthAuthenticated;
      final bool isLoggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !isLoggingIn) {
        return '/login';
      }
      if (loggedIn && isLoggingIn) {
        return '/pull-requests';
      }
      return null;
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
