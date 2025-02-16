class SignUpModel {
  String email;
  String name;
  String password;
  String passwordConfirm;

  SignUpModel({
    required this.email,
    required this.name,
    required this.password,
    required this.passwordConfirm
  });

  static SignUpModel empty() {
    return SignUpModel(
        email: "",
        name: "",
        password: "",
        passwordConfirm: ""
    );
  }

  static Map<String, dynamic> toMap(SignUpModel data) {
    return {
      'email': data.email,
      'name': data.name,
      'password': data.password,
      'passwordConfirm': data.passwordConfirm,
    };
  }
}