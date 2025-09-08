part of 'presence_cubit.dart';

sealed class PresenceState extends Equatable {
  const PresenceState();

  @override
  List<Object> get props => [];
}

final class PresenceInitial extends PresenceState {}
final class PresenceLoading extends PresenceState {}
final class DeviceChecking extends PresenceState {}

final class PresenceSuccess extends PresenceState {
  final bool status;

  const PresenceSuccess(this.status);

  @override
  List<Object> get props => [status];
}

final class PresenceFailed extends PresenceState {
  final String message;

  const PresenceFailed(this.message);

  @override
  List<Object> get props => [message];
}