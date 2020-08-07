import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/AddDevicePresenter.dart';

class AddDevice extends StatefulWidget {
  final AddDevicePresenter presenter;
  final platform;

  AddDevice({this.presenter, this.platform});

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> implements AddDeviceView {
  String error = '';
  final _deviceNameController = TextEditingController();
  final _osVersionController = TextEditingController();

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new device'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //TextField for device name
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Device Name',
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _deviceNameController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text.';
                }
              },
            ),
            //TextField for OS VERSION
            TextFormField(
              decoration: InputDecoration(
                hintText: 'OS Version',
              ),
              keyboardType: TextInputType.text,
              controller: _osVersionController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text.';
                }
              },
            ),
            Text(error),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return RaisedButton(
      onPressed: () {
        this.widget.presenter.saveDeviceData(
              deviceName: _deviceNameController.text,
              osVersion: _osVersionController.text,
              platform: this.widget.platform,
            );
      },
      child: Text('Save'),
    );
  }

  Widget successfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Successful"),
          content: new Text("Data has been successfully added."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _osVersionController.text = "";
                _deviceNameController.text = "";
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _osVersionController.dispose();
    super.dispose();
  }
}

class AddDeviceView {
  void successfulDialog() {}
}
