part of 'active_account_bloc.dart';

sealed class ActiveAccountEvent extends Equatable {
  const ActiveAccountEvent();

  @override
  List<Object> get props => [];
}

class ActiveAccountEv extends ActiveAccountEvent {
  final SignUpModel model;
  final String activeCode;

  const ActiveAccountEv({
    required this.model,
    required this.activeCode
  });
}