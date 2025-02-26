part of 'active_account_bloc.dart';

sealed class ActiveAccountState extends Equatable {
  const ActiveAccountState();

  @override
  List<Object> get props => [];
}

final class ActiveAccountInitial extends ActiveAccountState {}
final class ActiveAccountLoading extends ActiveAccountState {}
final class ActiveAccountFailure extends ActiveAccountState {
  final int statusCode;
  final String message;

  const ActiveAccountFailure({
    required this.statusCode,
    required this.message
  });
}

final class ActiveAccountSuccess extends ActiveAccountState {
  final String message;

  const ActiveAccountSuccess({
    required this.message
  });
}
