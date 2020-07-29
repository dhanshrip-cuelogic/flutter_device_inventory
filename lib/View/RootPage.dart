import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Presenter/MyHomePagePresenter.dart';
import 'package:flutterdeviceinventory/Presenter/PlatformSelectionPresenter.dart';
import 'package:flutterdeviceinventory/View/PlatformSelectionPage.dart';
import 'MyHomePage.dart';

class RootPage extends StatefulWidget {
  final DbManager auth;

  RootPage({@required this.auth});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  FirebaseUser currentUser;
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user == null) {
          signOut();
        } else {
          currentUser = user;
          signedIn(user);
        }
      });
    });
    super.initState();
  }

  void signedIn(FirebaseUser user) {
    if (user.isEmailVerified) {
      setState(() {
        _authStatus = AuthStatus.signedIn;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.notSignedIn;
      });
    }
  }

  void signOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.signedIn:
        return PlatformSelectionPage(
            presenter: PlatformSelectionPresenter(), signOut: signOut);
      case AuthStatus.notSignedIn:
        return MyHomePage(presenter: MyHomePagePresenter(), signedIn: signedIn);
    }
  }
}
