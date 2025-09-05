part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final String email;

  const AuthSuccess(this.email);

  @override
  List<Object> get props => [email];
}
final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

final class SingOut extends AuthState {
  final bool status;

  const SingOut(this.status);

  @override
  List<Object> get props => [status];
}
