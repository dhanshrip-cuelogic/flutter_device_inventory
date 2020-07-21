class UserData {
  static final UserData _appData = new UserData._internal();

  String user;

  factory UserData() {
    return _appData;
  }
  UserData._internal();
}

final userData = UserData();
