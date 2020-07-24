import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';

class DeviceDetails extends StatefulWidget {
  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  @override
  Widget build(BuildContext context) {
    final Device device = ModalRoute.of(context).settings.arguments;

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
              deviceID(device.key),
              deviceName(device.deviceName),
              osVersion(device.osVersion),
              historyButton(),
            ],
          ),
        ));
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

  Widget deviceName(String name) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Device Name'),
        ),
        Expanded(
          child: TextFormField(
            enabled: false,
            initialValue: name,
          ),
        )
      ],
    );
  }

  Widget osVersion(String osVersion) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('OS version'),
        ),
        Expanded(
          child: TextFormField(
            enabled: false,
            initialValue: osVersion,
          ),
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
