part of 'notification_turn_bloc.dart';

sealed class NotificationTurnState extends Equatable {
  const NotificationTurnState();

  @override
  List<Object> get props => [];
}

final class NotificationTurnInitial extends NotificationTurnState {}
final class NotificationTurnLoading extends NotificationTurnState {}
final class NotificationTurnFailure extends NotificationTurnState {
  final String message;

  const NotificationTurnFailure({
    required this.message
  });
}

final class NotificationTurnSuccess extends NotificationTurnState {
  final bool on;

  const NotificationTurnSuccess({
    required this.on
  });
}
