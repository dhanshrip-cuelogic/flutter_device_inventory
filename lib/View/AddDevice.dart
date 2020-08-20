import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/AddDevicePresenter.dart';
import 'package:flutterdeviceinventory/View/AlertDialogClass.dart';

class AddDevice extends StatefulWidget {
  final AddDevicePresenter presenter;
  final platform;

  AddDevice({this.presenter, this.platform});

  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> implements AddDeviceView {
  String error = '';
  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _osVersionController = TextEditingController();
  final _displayController = TextEditingController();
  final _ramController = TextEditingController();
  final _processorController = TextEditingController();
  AlertDialogClass alertDialog;

  @override
  void initState() {
    this.widget.presenter.setView = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    alertDialog = AlertDialogClass(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add new device'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(40.0),
          child: SingleChildScrollView(
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
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Display',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _displayController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'RAM',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _ramController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Processor',
                  ),
                  keyboardType: TextInputType.text,
                  controller: _processorController,
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
        ),
      ),
    );
  }

  Widget saveButton() {
    return RaisedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          this.widget.presenter.saveDeviceData(
                deviceName: _deviceNameController.text,
                osVersion: _osVersionController.text,
                display: _displayController.text,
                ram: _ramController.text,
                processor: _processorController.text,
                platform: this.widget.platform,
              );
        }
      },
      child: Text('Save'),
    );
  }

  void afterAlertDialog() {
    _osVersionController.text = "";
    _deviceNameController.text = "";
    _displayController.text = "";
    _ramController.text = "";
    _processorController.text = "";
  }

  @override
  Widget successfulDialog() {
    alertDialog.displayAlertDialog(
        "Successful",
        "Data has been successfully added.",
        true,
        afterAlertDialog,
        false,
        () {});
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _osVersionController.dispose();
    _displayController.dispose();
    _ramController.dispose();
    _processorController.dispose();
    super.dispose();
  }
}

class AddDeviceView {
  void successfulDialog() {}
}
