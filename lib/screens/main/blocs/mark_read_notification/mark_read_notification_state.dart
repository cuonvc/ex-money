part of 'mark_read_notification_bloc.dart';

sealed class MarkReadNotificationState extends Equatable {
  const MarkReadNotificationState();

  @override
  List<Object> get props => [];
}

final class MarkReadNotificationInitial extends MarkReadNotificationState {}
final class MarkReadNotificationLoading extends MarkReadNotificationState {}
final class MarkReadNotificationFailure extends MarkReadNotificationState {
  final String message;

  const MarkReadNotificationFailure({
    required this.message
  });
}

final class MarkReadNotificationSuccess extends MarkReadNotificationState {
  final bool result;

  const MarkReadNotificationSuccess({
    required this.result
  });
}
