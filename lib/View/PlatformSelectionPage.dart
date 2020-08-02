import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/PlatformSelectionModel.dart';
import 'package:flutterdeviceinventory/Presenter/PlatformSelectionPresenter.dart';
import 'package:flutterdeviceinventory/View/SelectListPath.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatformSelectionView {
  void refreshState(PlatformSelectionModel model) {}
}

class PlatformSelectionPage extends StatefulWidget {
  final PlatformSelectionPresenter presenter;
  final VoidCallback signOut;

  PlatformSelectionPage({this.presenter, this.signOut});

  @override
  _PlatformSelectionPageState createState() => _PlatformSelectionPageState();
}

class _PlatformSelectionPageState extends State<PlatformSelectionPage>
    implements PlatformSelectionView {
  PlatformSelectionModel _model;
  DbManager _auth;

  @override
  void initState() {
    this.widget.presenter.setView = this;
    _auth = DbManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Selection'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              removeUser();
              _auth.signOut();
              widget.signOut();
            },
            child: Text("Logout"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _model.platforms.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.mobile_screen_share),
            title: Text(_model.platforms[index]),
            onTap: () {
              _redirectToDeviceList();
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }

  @override
  void refreshState(PlatformSelectionModel model) {
    setState(() {
      _model = model;
    });
  }

  void _redirectToDeviceList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SelectListPath()));
  }

  void removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }
}
