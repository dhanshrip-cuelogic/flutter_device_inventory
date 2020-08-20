import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdeviceinventory/View/SignInPage.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:connectivity/connectivity.dart';

class Presenter {
  set setView(SignInView value) {}

  void checkUserInDatabase(
      {@required String email, @required String password, @required appUser}) {}

  void validateAndLogin(
      {@required String email, @required String password, @required appUser}) {}
}

class SignInPresenter implements Presenter {
  SignInView _view;
  DbManager _auth = DbManager();
  ConnectivityResult result;
  Connectivity _connectivity = Connectivity();

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
    _view.dialogAfterLogin();
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        _view.popDialog();
        _view.showDialogContent("No internet connection",
            "Please check your network connectivity.");
      } else if (result == ConnectivityResult.mobile) {
        checkUserInDatabase(email: email, password: password, appUser: appUser);
      } else if (result == ConnectivityResult.wifi) {
        _view.popDialog();
        _view.wifiConnectionDialog("Connected to wifi",
            "Your device is connected to wifi. Please make sure that wifi has access to the internet.");
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void checkUserInDatabase(
      {@required String email,
      @required String password,
      @required appUser}) async {
    var isValidUser = await _auth.checkUser(appUser, email);
    if (isValidUser) {
      signInUser(email, password);
    } else {
      _view.showError("User not found");
    }
  }

  void signInUser(String email, String password) async {
    try {
//      _view.dialogAfterLogin();
      FirebaseUser user = await _auth.signIn(email, password);
      // add try - catch while verifying for email as well.
      if (await _auth.isEmailVerified(user)) {
        _view.popDialog();
        _view.clearFields();
        _view.redirectToPlatformSelectionPage(user);
      } else {
        _view.popDialog();
        _view.clearFields();
        _view.showDialogContent("Verify your account",
            "Link has been already sent to your email account please verify it to move forward.");
      }
    } catch (error) {
      _view.popDialog();
      _view.showError(error);
    }
  }
}
