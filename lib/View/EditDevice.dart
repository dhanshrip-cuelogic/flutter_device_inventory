import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/EditDevicePresenter.dart';

class EditDevice extends StatefulWidget {
  final EditDevicePresenter presenter;
  final device;
  final platform;

  EditDevice({this.presenter, this.device, this.platform});

  @override
  _EditDeviceState createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> implements EditDeviceView {
  TextEditingController _nameController;
  TextEditingController _osVersionController;

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nameController =
        TextEditingController(text: this.widget.device.deviceName);
    _osVersionController =
        TextEditingController(text: this.widget.device.osVersion);

    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            deviceID(this.widget.device.key),
            deviceName(_nameController),
            osVersion(_osVersionController),
            saveButton(
                key: this.widget.device.key, status: this.widget.device.status),
          ],
        ),
      ),
    );
  }

  Widget deviceID(String key) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Device ID'),
        ),
        Expanded(
          child: TextFormField(
            enabled: false,
            initialValue: key,
          ),
        )
      ],
    );
  }

  Widget deviceName(TextEditingController nameController) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Device Name'),
        ),
        Expanded(
          child: TextFormField(
            controller: nameController,
          ),
        )
      ],
    );
  }

  Widget osVersion(TextEditingController osController) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('OS version'),
        ),
        Expanded(
          child: TextFormField(
            controller: osController,
          ),
        )
      ],
    );
  }

  Widget saveButton({String key, String status}) {
    return RaisedButton(
      onPressed: () {
        this.widget.presenter.updateDevice(
            key: key,
            name: _nameController.text,
            osVersion: _osVersionController.text,
            status: status,
            platform: this.widget.platform);
        updateSuccessfulDialog();
      },
      child: Text('Save'),
    );
  }

  Widget updateSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Successful"),
          content: new Text("Data has been successfully updated."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
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
    _osVersionController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

class EditDeviceView {}
