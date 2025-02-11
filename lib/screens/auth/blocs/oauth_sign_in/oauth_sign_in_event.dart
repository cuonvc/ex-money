part of 'oauth_sign_in_bloc.dart';

sealed class OAuthSignInEvent extends Equatable {
  const OAuthSignInEvent();

  @override
  List<Object> get props => [];
}

class OAuthSignInEv extends OAuthSignInEvent {
  final String token;
  final String provider;

  const OAuthSignInEv({
    required this.token,
    required this.provider
  });
}