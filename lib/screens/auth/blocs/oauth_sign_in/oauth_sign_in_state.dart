part of 'oauth_sign_in_bloc.dart';

sealed class OAuthSignInState extends Equatable {
  const OAuthSignInState();

  @override
  List<Object> get props => [];
}

final class OAuthSignInInitial extends OAuthSignInState {}
final class OAuthSignInLoading extends OAuthSignInState {}
final class OAuthSignInFailure extends OAuthSignInState {
  final int statusCode;
  final String message;

  const OAuthSignInFailure({
    required this.statusCode,
    required this.message
  });
}

final class OAuthSignInSuccess extends OAuthSignInState {
  final SignInResponse response;

  const OAuthSignInSuccess({
    required this.response
  });
}
