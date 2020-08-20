import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceHistory.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';

class DeviceHistoryPage extends StatefulWidget {
  final String deviceKey;

  DeviceHistoryPage({this.deviceKey});

  @override
  _DeviceHistoryPageState createState() => _DeviceHistoryPageState();
}

class _DeviceHistoryPageState extends State<DeviceHistoryPage> {
  DbManager _dbManager = DbManager();
  List<DeviceHistory> deviceHistory = [];
  StreamSubscription<Event> historyEvent;
  Widget viewBody;

  @override
  void initState() {
    viewBody = Container(child: Center(child: CircularProgressIndicator()));
    fetchDeviceHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device History'),
        centerTitle: true,
      ),
      body: viewBody,
    );
  }

  Widget createList() {
    return ListView.separated(
      reverse: true,
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
  }

  void fetchDeviceHistory() {
    _dbManager.getDeviceHistory(this.widget.deviceKey).then((value) {
      Query query = value;
      historyEvent = query.onChildAdded.listen((event) {
        DeviceHistory deviceData = DeviceHistory.fromSnapshot(event.snapshot);
        setState(() {
          viewBody = createList();
          deviceHistory.add(deviceData);
        });
      });
    });
  }

  @override
  void dispose() {
    historyEvent.cancel();
    super.dispose();
  }
}
