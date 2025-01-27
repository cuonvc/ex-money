part of 'mark_read_notification_bloc.dart';

sealed class MarkReadNotificationEvent extends Equatable {
  const MarkReadNotificationEvent();

  @override
  List<Object> get props => [];
}

class MarkReadNotificationEv extends MarkReadNotificationEvent {
  final num? id;
  final bool all;

  const MarkReadNotificationEv({
    required this.id,
    required this.all
  });
}
