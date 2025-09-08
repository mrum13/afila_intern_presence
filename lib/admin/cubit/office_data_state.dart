part of 'office_data_cubit.dart';

sealed class OfficeDataState extends Equatable {
  const OfficeDataState();

  @override
  List<Object> get props => [];
}

final class OfficeDataInitial extends OfficeDataState {}
final class OfficeDataLoading extends OfficeDataState {}
final class GetOfficeDataSuccess extends OfficeDataState {
  final OfficeDataModel data;

  const GetOfficeDataSuccess(this.data);

  @override
  List<Object> get props => [data];
}
final class SetOfficeDataSuccess extends OfficeDataState {
  final bool data;

  const SetOfficeDataSuccess(this.data);

  @override
  List<Object> get props => [data];
}
final class OfficeDataFailed extends OfficeDataState {
  final String message;

  const OfficeDataFailed(this.message);

  @override
  List<Object> get props => [message];
}
