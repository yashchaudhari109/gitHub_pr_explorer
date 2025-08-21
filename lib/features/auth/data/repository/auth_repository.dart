import 'package:github_pr_explorer/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRepository {
  Future<void> login(String fakeToken);
  Future<String?> getToken();
  Future<void> logout();
}

// The implementation that handles the data logic.
class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const _tokenKey = 'fake_github_token';

  AuthRepositoryImpl(this.sharedPreferences);

  @override
  Future<String?> getToken() async {
    final token = sharedPreferences.getString(_tokenKey);
    if (token != null) {
      return token;
    } else {
      // Return null if no token is found
      return null;
    }
  }

  @override
  Future<void> login(String fakeToken) async {
    try {
      await sharedPreferences.setString(_tokenKey, fakeToken);
    } catch (e) {
      // specific error handling here
      throw CacheException(message: 'Failed to save token.');
    }
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(_tokenKey);
  }
}
