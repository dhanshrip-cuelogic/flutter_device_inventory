import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/EditDevicePresenter.dart';
import 'package:flutterdeviceinventory/View/AlertDialogClass.dart';

class EditDevice extends StatefulWidget {
  final EditDevicePresenter presenter;
  final Device device;
  final platform;

  EditDevice({this.presenter, this.device, this.platform});

  @override
  _EditDeviceState createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> implements EditDeviceView {
  TextEditingController _nameController;
  TextEditingController _osVersionController;
  TextEditingController _displayController;
  TextEditingController _ramController;
  TextEditingController _processorController;
  AlertDialogClass alertDialogClass;

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    alertDialogClass = AlertDialogClass(context);
    _nameController =
        TextEditingController(text: this.widget.device.deviceName);
    _osVersionController =
        TextEditingController(text: this.widget.device.osVersion);
    _displayController =
        TextEditingController(text: this.widget.device.display);
    _ramController = TextEditingController(text: this.widget.device.ram);
    _processorController =
        TextEditingController(text: this.widget.device.processor);

    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              deviceID(this.widget.device.key),
              deviceName(_nameController),
              osVersion(_osVersionController),
              display(_displayController),
              ram(_ramController),
              processor(_processorController),
              saveButton(
                  key: this.widget.device.key,
                  status: this.widget.device.status,
                  issuedUser: this.widget.device.issuedUser,
                  checkin: this.widget.device.checkin,
                  display: this.widget.device.display,
                  ram: this.widget.device.ram,
                  processor: this.widget.device.processor),
            ],
          ),
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

  Widget display(TextEditingController displayController) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Display'),
        ),
        Expanded(
          child: TextFormField(
            controller: displayController,
          ),
        )
      ],
    );
  }

  Widget ram(TextEditingController ramController) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('RAM'),
        ),
        Expanded(
          child: TextFormField(
            controller: ramController,
          ),
        )
      ],
    );
  }

  Widget processor(TextEditingController processorController) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Processor'),
        ),
        Expanded(
          child: TextFormField(
            controller: processorController,
          ),
        )
      ],
    );
  }

  Widget saveButton(
      {String key,
      String status,
      String issuedUser,
      String checkin,
      String display,
      String ram,
      String processor}) {
    return RaisedButton(
      onPressed: () {
        this.widget.presenter.updateDevice(
            key: key,
            name: _nameController.text,
            osVersion: _osVersionController.text,
            status: status,
            issuedUser: issuedUser,
            checkin: checkin,
            display: _displayController.text,
            ram: _ramController.text,
            processor: _processorController.text,
            platform: this.widget.platform);
        updateSuccessfulDialog();
      },
      child: Text('Save'),
    );
  }

  Widget updateSuccessfulDialog() {
    alertDialogClass.displayAlertDialog("Successful",
        "Data has been successfully updated.", true, () {}, false, () {});
  }

  @override
  void dispose() {
    _osVersionController.dispose();
    _nameController.dispose();
    _displayController.dispose();
    _ramController.dispose();
    _processorController.dispose();
    super.dispose();
  }
}

class EditDeviceView {}
