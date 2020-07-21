import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/SignInPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/SignUpPresenter.dart';
import 'package:flutterdeviceinventory/View/MyHomePage.dart';
import 'package:flutterdeviceinventory/Presenter/MyHomePagePresenter.dart';
import 'package:flutterdeviceinventory/View/SignInPage.dart';
import 'package:flutterdeviceinventory/View/SignUpPage.dart';
import 'View/PlatformSelectionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(presenter: MyHomePagePresenter()),
      routes: {
        '/signinPage': (BuildContext context) =>
            SignInPage(presenter: SignInPresenter()),
        '/signupPage': (BuildContext context) =>
            SignUpPage(presenter: SignUpPresenter()),
        '/platformSelectionPage': (BuildContext context) =>
            PlatformSelectionPage(),
      },
    );
  }
}
