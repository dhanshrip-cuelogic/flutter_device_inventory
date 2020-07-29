import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/UserData.dart';
import 'package:flutterdeviceinventory/Presenter/SignInPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/SignUpPresenter.dart';
import 'package:flutterdeviceinventory/View/ForgotPassword.dart';

import 'SignUpPage.dart';

class SignInView {
  void redirectToPlatformSelectionPage(FirebaseUser user) {}
  void clearFields() {}
  void requestToVerify() {}
}

class SignInPage extends StatefulWidget {
  final SignInPresenter presenter;
  final void Function(FirebaseUser) signedIn;

  SignInPage({this.presenter, this.signedIn});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> implements SignInView {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                controller: _emailController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text.';
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text.';
                  }
                },
              ),
              Text(error),
              loginButton(),
              signUpButton(),
              forgotPassword(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          this.widget.presenter.validateAndLogin(
              email: _emailController.text, password: _passwordController.text);
        }
      },
      child: Text('Login'),
    );
  }

  void signedIn(FirebaseUser user) {
    widget.signedIn(user);
  }

  Widget signUpButton() {
    if (userData.user == 'Employee') {
      return RaisedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpPage(
                      presenter: SignUpPresenter(), signedIn: signedIn)));
        },
        child: Text('SignUp'),
      );
    } else {
      return Container();
    }
  }

  Widget forgotPassword() {
    return Expanded(
      child: GestureDetector(
        child: Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.blue,
            fontStyle: FontStyle.normal,
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
      ),
    );
  }

  @override
  void redirectToPlatformSelectionPage(FirebaseUser user) {
    widget.signedIn(user);
    Navigator.pop(context);
  }

  @override
  void requestToVerify() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text(
              "Link has been already sent to your email account please verify it to move forward."),
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
  void clearFields() {
    _emailController.text = '';
    _passwordController.text = '';
  }
}
