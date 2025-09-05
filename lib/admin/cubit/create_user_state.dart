part of 'create_user_cubit.dart';

sealed class CreateUserState extends Equatable {
  const CreateUserState();

  @override
  List<Object> get props => [];
}

final class CreateUserInitial extends CreateUserState {}

final class CreateUserLoading extends CreateUserState {}
final class CreateUserSuccess extends CreateUserState {
  final bool status;

  const CreateUserSuccess(this.status);

  @override
  List<Object> get props => [status];
}
final class CreateUserError extends CreateUserState {
  final String message;

  const CreateUserError(this.message);

  @override
  List<Object> get props => [message];
}