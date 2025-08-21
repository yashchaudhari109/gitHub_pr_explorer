import 'package:equatable/equatable.dart';

// The base class for all authentication-related events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event dispatched to check the initial authentication status when the app starts.
class AuthStatusChecked extends AuthEvent {}

/// Event dispatched when the user attempts to log in.
class AuthLoginRequested extends AuthEvent {
  // A fake token is passed for simulation purposes.
  final String fakeToken;

  const AuthLoginRequested({required this.fakeToken});

  @override
  List<Object> get props => [fakeToken];
}

/// Event dispatched when the user logs out.
class AuthLogoutRequested extends AuthEvent {}
