class AuthToken {
  static final AuthToken _instance = AuthToken._internal();

  factory AuthToken() {
    return _instance;
  }

  AuthToken._internal();

  String? token;

  void setToken(String value) {
    token = value;
  }

  String? get getToken => token;
}
