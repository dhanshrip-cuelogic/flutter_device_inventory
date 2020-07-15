import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
