import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';

class DeviceDetails extends StatefulWidget {
  final Device device;

  DeviceDetails({this.device});

  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            deviceID(),
            deviceName(),
            osVersion(),
            historyButton(),
          ],
        ),
      ),
    );
  }

  Widget deviceID() {
    return Row(
      children: <Widget>[
        Text('Device ID'),
        TextFormField(
          enabled: false,
          initialValue: this.widget.device.key,
        )
      ],
    );
  }

  Widget deviceName() {
    return Row(
      children: <Widget>[
        Text('Device Name'),
        TextFormField(
          enabled: false,
          initialValue: this.widget.device.deviceName,
        )
      ],
    );
  }

  Widget osVersion() {
    return Row(
      children: <Widget>[
        Text('Device Name'),
        TextFormField(
          enabled: false,
          initialValue: this.widget.device.osVersion,
        )
      ],
    );
  }

  Widget historyButton() {
    return RaisedButton(
      onPressed: () {},
      child: Text('Device History'),
    );
  }
}
