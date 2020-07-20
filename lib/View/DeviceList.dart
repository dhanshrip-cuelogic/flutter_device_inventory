import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/UserData.dart';

class DeviceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device List'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(userData.user),
      ),
    );
  }
}
