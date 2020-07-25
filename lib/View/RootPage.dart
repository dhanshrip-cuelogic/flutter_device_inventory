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
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _authStatus =
            user == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
    super.initState();
  }

  void signedIn() {
    setState(() {
      print('This is callback from RootPage.');
      _authStatus = AuthStatus.signedIn;
    });
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
        return MyHomePage(
          presenter: MyHomePagePresenter(),
          signedIn: signedIn,
        );
    }
  }
}
