import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/View/SignUpPage.dart';

class Presenter {
  set setView(SignUpView value) {}
  bool validateEmail({String email}) {}
  bool validateCueID({String cueId}) {}
  bool validatePassword({String password}) {}
  void validateAndSave() {}
}

class SignUpPresenter implements Presenter {
  SignUpView _signUpView;
  DbManager _auth = DbManager();

  @override
  void set setView(SignUpView value) {
    _signUpView = value;
  }

  bool validateEmail({String email}) {
    RegExp exp = new RegExp(r"^([a-z]+)([.]{1})([a-z]+)(@cuelogic.com)$");
    String str = email;
    return exp.hasMatch(str);
  }

  bool validateCueID({String cueId}) {
    RegExp exp = new RegExp(r"^(Cue)([0-9]{5})$");
    String str = cueId;
    return exp.hasMatch(str);
  }

  // It will validate password with the given regular expression.
  bool validatePassword({String password}) {
    RegExp exp = new RegExp(r"^([A-Z]+)([a-z]?.*)([!@#$%^&*.].*)([0-9].*)$");
    String str = password;
    return exp.hasMatch(str);
  }

  @override
  void validateAndSave(
      {@required String email,
      @required String password,
      @required String cueid,
      @required String username}) async {
    FirebaseUser user = await _auth.signUp(email, password);
    try {
      await user.sendEmailVerification();
      _auth.saveEmployeeData(
          userid: user.uid, email: email, cueid: cueid, username: username);
      _signUpView.clearFields();
      _signUpView.showVerifyEmailDialog();
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
  }
}
