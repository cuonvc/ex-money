part of 'notification_turn_bloc.dart';

sealed class NotificationTurnEvent extends Equatable {
  const NotificationTurnEvent();

  @override
  List<Object> get props => [];
}

class NotificationTurnEv extends NotificationTurnEvent {
  final bool on;

  const NotificationTurnEv({
    required this.on
  });
}
