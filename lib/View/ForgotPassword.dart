import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  DbManager _auth;

  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _auth = DbManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      setState(() {
        _emailController.text = "";
        print("-- ${error.message}");
      });
    }).then((value) {
      setState(() {
        _emailController.text = "";
        showAlertDialog("Reset link sent",
            "Link has been already sent to your email account please follow the instructions to reset password.");
      });
    });
  }

  void showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
