import 'package:get_it/get_it.dart';
import 'package:github_pr_explorer/core/api/api_client.dart';
import 'package:github_pr_explorer/features/auth/data/repository/auth_repository.dart';
import 'package:github_pr_explorer/features/pull_requests/data/repository/pull_request_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Create a global instance of GetIt
final getIt = GetIt.instance;

/// Configures and registers all the dependencies for the application.
Future<void> configureDependencies() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<http.Client>(http.Client());

  // Core API Services
  getIt.registerSingleton<ApiClient>(ApiClient(getIt<http.Client>()));

  // Feature Repositories
  // We register them as lazy singletons, so they are only created when first requested.
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<PullRequestRepository>(
    () => PullRequestRepositoryImpl(getIt<ApiClient>()),
  );
}
