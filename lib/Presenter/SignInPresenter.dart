import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdeviceinventory/View/SignInPage.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';

class Presenter {
  set setView(SignInView value) {}
  void validateAndLogin() {}
}

class SignInPresenter implements Presenter {
  SignInView _view;
  DbManager _auth = DbManager();

  @override
  void set setView(SignInView value) {
    _view = value;
  }

  @override
  void validateAndLogin(
      {@required String email, @required String password}) async {
    FirebaseUser user = await _auth.signIn(email, password);
    if (await _auth.isEmailVerified(user)) {
      _view.clearFields();
      _view.redirectToPlatformSelectionPage();
    } else {
      _view.clearFields();
      _view.requestToVerify();
    }
  }
}
