import 'package:repository/repository.dart';

abstract class UserRepository {
  Future<dynamic> signIn(SignInModel signModel);
}