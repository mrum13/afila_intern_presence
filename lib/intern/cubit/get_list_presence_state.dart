part of 'get_list_presence_cubit.dart';

sealed class GetListPresenceState extends Equatable {
  const GetListPresenceState();

  @override
  List<Object> get props => [];
}

final class GetListPresenceInitial extends GetListPresenceState {}

final class GetListPresenceLoading extends GetListPresenceState {}

final class GetListPresenceSuccess extends GetListPresenceState {
  final List<PresenceModel> data;
  
  const GetListPresenceSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class GetListPresenceFailed extends GetListPresenceState {
  final String message;
  
  const GetListPresenceFailed(this.message);

  @override
  List<Object> get props => [message];
}