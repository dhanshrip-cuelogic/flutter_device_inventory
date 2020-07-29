import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceHistory.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';

class DeviceHistoryPage extends StatefulWidget {
  final String deviceKey;

  DeviceHistoryPage({this.deviceKey});

  @override
  _DeviceHistoryPageState createState() => _DeviceHistoryPageState();
}

class _DeviceHistoryPageState extends State<DeviceHistoryPage> {
  DbManager _dbManager = DbManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device History'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _dbManager.getDeviceHistory(widget.deviceKey),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.data == null) {
            return Container();
          }
          List<DeviceHistory> deviceHistory = snapshot.data;
          return ListView.separated(
            itemCount: deviceHistory.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    // Name row,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('User'),
                        Text(deviceHistory[index].user),
                      ],
                    ),
                    // Checkin row,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Checkin'),
                        Text(deviceHistory[index].checkin),
                      ],
                    ),
                    // Checkout row,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Checkout'),
                        Text(deviceHistory[index].checkout),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
