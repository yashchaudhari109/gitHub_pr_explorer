import 'package:equatable/equatable.dart';

// The base class for all authentication-related states.
// Extending Equatable allows for efficient UI updates by preventing unnecessary rebuilds
// if the same state is emitted consecutively.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// The initial state of the AuthBloc before any processing has occurred.
class AuthInitial extends AuthState {}

/// State representing that an authentication process (login, logout, status check) is in progress.
/// The UI can use this to show a loading indicator.
class AuthLoading extends AuthState {}

/// State representing that the user is successfully authenticated.
/// It carries the token, which can be used by the UI or other parts of the app.
class AuthAuthenticated extends AuthState {
  final String token;

  const AuthAuthenticated({required this.token});

  @override
  List<Object> get props => [token];
}

/// State representing that the user is not authenticated.
/// The UI will use this state to show the Login screen.
class AuthUnauthenticated extends AuthState {}

/// State representing that an error occurred during an authentication process.
/// It carries an error message that can be displayed to the user.
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
