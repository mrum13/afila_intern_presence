part of 'create_employee_cubit.dart';

sealed class CreateEmployeeState extends Equatable {
  const CreateEmployeeState();

  @override
  List<Object> get props => [];
}

final class CreateEmployeeInitial extends CreateEmployeeState {}

final class CreateEmployeeLoading extends CreateEmployeeState {}
final class CreateEmployeeSuccess extends CreateEmployeeState {
  final bool status;

  const CreateEmployeeSuccess(this.status);

  @override
  List<Object> get props => [status];
}
final class CreateEmployeeError extends CreateEmployeeState {
  final String message;

  const CreateEmployeeError(this.message);

  @override
  List<Object> get props => [message];
}