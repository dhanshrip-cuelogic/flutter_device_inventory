import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/PlatformSelectionModel.dart';
import 'package:flutterdeviceinventory/Presenter/PlatformSelectionPresenter.dart';

class PlatformSelectionView {
  void refreshState(PlatformSelectionModel model) {}
}

class PlatformSelectionPage extends StatefulWidget {
  final PlatformSelectionPresenter presenter;

  PlatformSelectionPage({this.presenter});
  @override
  _PlatformSelectionPageState createState() => _PlatformSelectionPageState();
}

class _PlatformSelectionPageState extends State<PlatformSelectionPage>
    implements PlatformSelectionView {
  PlatformSelectionModel _model;

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Selection'),
        centerTitle: true,
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
    Navigator.pushNamed(context, '/deviceList');
  }
}
