import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_event.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_state.dart';
import 'package:github_pr_explorer/features/auth/data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await _authRepository.getToken();
      if (token != null) {
        emit(AuthAuthenticated(token: token));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.login(event.fakeToken);
      emit(AuthAuthenticated(token: event.fakeToken));
    } catch (e) {
      emit(AuthFailure(message: 'Failed to store token: ${e.toString()}'));
      // revert to unauthenticated state after showing error
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: 'Failed to logout: ${e.toString()}'));
    }
  }
}
