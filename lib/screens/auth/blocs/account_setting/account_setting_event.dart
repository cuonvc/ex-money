part of 'account_setting_bloc.dart';

sealed class AccountSettingEvent extends Equatable {
  const AccountSettingEvent();

  @override
  List<Object> get props => [];
}

class AccountSettingEv extends AccountSettingEvent {
  final String name;

  const AccountSettingEv({
    required this.name
  });
}