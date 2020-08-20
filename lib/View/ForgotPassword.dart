import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'AlertDialogClass.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  DbManager _auth;
  bool gotError = false;
  PlatformException err;
  TextEditingController _emailController = TextEditingController();
  AlertDialogClass alertDialogClass;

  @override
  void initState() {
    _auth = DbManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    alertDialogClass = AlertDialogClass(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                onPressed: () {
                  resetPassword();
                },
                child: Text('Reset Password'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void resetPassword() async {
    _auth.resetPassword(_emailController.text).catchError((onError) {
      PlatformException error = onError;
      gotError = true;
      err = error;
    }).then((value) {
      // if got error then show dialog with error else successful dialog box.
      if (gotError == true) {
        showErrorMessage(err.message);
      } else {
        sendVerifyLink();
      }
    });
  }

  void sendVerifyLink() {
    setState(() {
      _emailController.text = "";
      showAlertDialog("Reset link sent",
          "Link has been already sent to your email account please follow the instructions to reset password.");
    });
  }

  void showErrorMessage(String message) {
    setState(() {
      showAlertDialog("Error", message);
      gotError = false;
    });
  }

  void showAlertDialog(String title, String content) {
    alertDialogClass.displayAlertDialog(
        title, content, true, () {}, false, () {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
