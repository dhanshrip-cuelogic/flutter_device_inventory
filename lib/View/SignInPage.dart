import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/UserData.dart';
import 'package:flutterdeviceinventory/Presenter/SignInPresenter.dart';

class SignInView {
  void redirectToPlatformSelectionPage() {}
  void clearFields() {}
  void requestToVerify() {}
}

class SignInPage extends StatefulWidget {
  final SignInPresenter presenter;

  SignInPage({this.presenter});

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
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                keyboardType: TextInputType.text,
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

  Widget signUpButton() {
    if (userData.user == 'Employee') {
      return RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signupPage');
        },
        child: Text('SignUp'),
      );
    } else {
      return Container();
    }
  }

  Widget forgotPassword() {
    return GestureDetector(
      child: Text(
        'Forgot Password',
        style: TextStyle(
          color: Colors.blue,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }

  @override
  void redirectToPlatformSelectionPage() {
    Navigator.pushNamed(context, '/platformSelectionPage');
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
                Navigator.of(context).popAndPushNamed('/signinPage');
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
