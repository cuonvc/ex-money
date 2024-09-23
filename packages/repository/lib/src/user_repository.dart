import 'package:repository/repository.dart';

abstract class UserRepository {
  Future<void> signIn(SignInModel signModel);
}