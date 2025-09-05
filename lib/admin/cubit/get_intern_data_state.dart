part of 'get_intern_data_cubit.dart';

sealed class GetInternDataState extends Equatable {
  const GetInternDataState();

  @override
  List<Object> get props => [];
}

final class GetInternDataInitial extends GetInternDataState {}

final class GetInternDataLoading extends GetInternDataState {}
final class GetInternDataSuccess extends GetInternDataState {
  final List<UserModel> data;

  const GetInternDataSuccess(this.data);

  @override
  List<Object> get props => [data];
}
final class GetInternDataError extends GetInternDataState {
  final String message;

  const GetInternDataError(this.message);

  @override
  List<Object> get props => [message];
}