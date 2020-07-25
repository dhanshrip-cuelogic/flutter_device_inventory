import 'package:flutterdeviceinventory/Model/HomePageModel.dart';
import 'package:flutterdeviceinventory/Presenter/MyHomePagePresenter.dart';
import 'package:flutterdeviceinventory/Presenter/SignInPresenter.dart';
import 'package:flutterdeviceinventory/View/HomePageView.dart';
import 'package:flutter/material.dart';

import 'SignInPage.dart';

class MyHomePage extends StatefulWidget {
  final MyHomePagePresenter presenter;
  final VoidCallback signedIn;

  MyHomePage({this.presenter, this.signedIn});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements HomePageView {
  HomePageModel _model;

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  @override
  void refreshState(HomePageModel model) {
    setState(() {
      _model = model;
    });
  }

  void redirectToSignInPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignInPage(
                  presenter: SignInPresenter(),
                  signedIn: signedIn,
                )));
  }

  void signedIn() {
    print('This is callback from HomePage.');
    widget.signedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('HomeScreen'),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: _model.users.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.accessibility),
              title: Text(_model.users[index]),
              onTap: () {
                this.widget.presenter.onListTileOnTap(index);
                redirectToSignInPage();
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
    );
  }
}
