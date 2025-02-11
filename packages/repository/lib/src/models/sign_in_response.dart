import 'package:repository/repository.dart';

class SignInResponse {
  Map<String, dynamic> accessTokenData;
  Map<String, dynamic> refreshTokenData;
  UserResponse user;

  SignInResponse({
    required this.accessTokenData,
    required this.refreshTokenData,
    required this.user
  });

  static SignInResponse fromMap(List data) {
    return SignInResponse(
      accessTokenData: data[0],
      refreshTokenData: data[1],
      user: UserResponse.fromMap(data[2])
    );
  }

  static List<dynamic> toMap(SignInResponse data) {

    return [
      data.accessTokenData,
      data.refreshTokenData,
      UserResponse.toMap(data.user)
    ];
  }
}