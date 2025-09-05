part of 'get_current_user_cubit.dart';

sealed class GetCurrentUserState extends Equatable {
  const GetCurrentUserState();

  @override
  List<Object> get props => [];
}

final class GetCurrentUserInitial extends GetCurrentUserState {}

final class GetCurrentUserLoading extends GetCurrentUserState {}

final class GetCurrentUserSuccess extends GetCurrentUserState {
  final InternModel data;
  
  const GetCurrentUserSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetCurrentUserFailed extends GetCurrentUserState {
  final String message;
  
  const GetCurrentUserFailed(this.message);

  @override
  List<Object> get props => [message];
}