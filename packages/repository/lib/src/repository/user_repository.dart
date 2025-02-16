import 'package:repository/repository.dart';

abstract class UserRepository {
  Future<dynamic> signUp(SignUpModel model);
  Future<dynamic> activeAccount(SignUpModel model, String activeCode);
  Future<dynamic> signIn(SignInModel signModel);
  Future<dynamic> oAuthSignIn(String token, String provider);
  Future<void> renewAccessToken();
  Future<dynamic> updateProfile(String name);
  Future<dynamic> turnNotification(bool on);
  Future<dynamic> changePassword(String oldPassword, String newPassword, String passwordConfirm);
  Future<dynamic> signOut();
}