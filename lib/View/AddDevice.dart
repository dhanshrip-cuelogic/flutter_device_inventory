import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/AddDevicePresenter.dart';

class AddDevice extends StatefulWidget {
  final AddDevicePresenter presenter;

  AddDevice({this.presenter});

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
              obscureText: true,
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
            osVersion: _osVersionController.text);
      },
      child: Text('Save'),
    );
  }
}

class AddDeviceView {}
