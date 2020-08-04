import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdeviceinventory/View/SignInPage.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';

class Presenter {
  set setView(SignInView value) {}

  void validateAndLogin(
      {@required String email, @required String password, @required appUser}) {}
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
      {@required String email,
      @required String password,
      @required appUser}) async {
    // Check whether the user is in admin list or not.
    var isValidUser = await _auth.checkUser(appUser, email);
    if (isValidUser) {
      signInUser(email, password);
    } else {
      _view.showError("User not found");
    }
  }

  void signInUser(String email, String password) async {
    try {
      _view.dialogAfterLogin();
      FirebaseUser user = await _auth.signIn(email, password);
      // add try - catch while verifying for email as well.
      if (await _auth.isEmailVerified(user)) {
        _view.popDialog();
        _view.clearFields();
        _view.redirectToPlatformSelectionPage(user);
      } else {
        _view.popDialog();
        _view.clearFields();
        _view.requestToVerify();
      }
    } catch (error) {
      _view.popDialog();
      print(error);
      _view.showError(error);
    }
  }
}
