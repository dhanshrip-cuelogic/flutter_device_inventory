import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/SignInPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/SignUpPresenter.dart';
import 'SignInPage.dart';

class SignUpView {
  void showVerifyEmailDialog() {}
  void clearFields() {}
  void dialogAfterSignUp() {}
  void popDialog() {}
  void showError(String errorMessage) {}
}

class SignUpPage extends StatefulWidget {
  final SignUpPresenter presenter;
  final void Function(FirebaseUser) signedIn;

  SignUpPage({this.presenter, this.signedIn});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> implements SignUpView {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _cueidController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String error = '';

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SignUp Page'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(50.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text.';
                    }

                    if (!this.widget.presenter.validateEmail(email: value)) {
                      return 'Please enter valid Cuelogic email address.';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'CueID',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _cueidController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text.';
                    }

                    if (!this.widget.presenter.validateCueID(cueId: value)) {
                      return 'Please enter valid CueID.';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                  ),
                  controller: _usernameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text.';
                    }

                    if (!this
                        .widget
                        .presenter
                        .validatePassword(password: value)) {
                      return 'Please enter Password stating with Capital and must include atleast one small letter, one special character and one digit';
                    }

                    return null;
                  },
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
                signUpButton(),
                Text('Already have an account?',
                    style: TextStyle(color: Colors.blue)),
                loginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // This will create a Raised Button for SignUp.
  Widget signUpButton() {
    return Builder(
      builder: (context) => RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            this.widget.presenter.validateAndSave(
                email: _emailController.text,
                password: _passwordController.text,
                cueid: _cueidController.text,
                username: _usernameController.text);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          }
        },
        child: Text('SignUp'),
      ),
    );
  }

// This will create a Raised Button for transition to SignIn Page.
  Widget loginButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignInPage(
                      presenter: SignInPresenter(),
                      signedIn: signedIn,
                    )));
      },
      child: Text('Login'),
    );
  }

  void signedIn(FirebaseUser user) {
    widget.signedIn(user);
  }

  @override
  void showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.pop(context);
                popDialog();
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
    _cueidController.text = '';
    _usernameController.text = '';
    _passwordController.text = '';
  }

  @override
  void showError(String errorMessage) {
    setState(() {
      error = errorMessage;
    });
  }

  @override
  void dialogAfterSignUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Please wait..."),
        );
      },
    );
  }

  @override
  void popDialog() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _cueidController.dispose();
    super.dispose();
  }
}
