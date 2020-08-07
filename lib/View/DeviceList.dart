import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/AddDevicePresenter.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceDetailsPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceListPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/EditDevicePresenter.dart';
import 'package:flutterdeviceinventory/View/AddDevice.dart';
import 'package:flutterdeviceinventory/View/EditDevice.dart';
import 'DeviceDetails.dart';
import 'dart:async';

class DeviceList extends StatefulWidget {
  final DeviceListPresenter presenter;
  final platform;

  DeviceList({this.presenter, this.platform});

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> implements DeviceListView {
  List<Device> devices = [];
  StreamSubscription<Event> devicesEvent;
  StreamSubscription<Event> devicesChangeEvent;
  DbManager _dbManager = DbManager();

  @override
  void initState() {
    this.widget.presenter.setView = this;
    _dbManager.fetchDevices(widget.platform).then((value) {
      Query query = value;
      devicesEvent =
          query.onChildAdded.listen(this.widget.presenter.childAddedEvent);
      devicesChangeEvent =
          query.onChildChanged.listen(this.widget.presenter.childUpdatedEvent);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device List'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddDevice(
                            presenter: AddDevicePresenter(),
                            platform: this.widget.platform,
                          )));
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].deviceName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showEditIcon(devices[index]),
                showDeleteIcon(devices[index].key, index),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DeviceDetails(
                            presenter: DeviceDetailsPresenter(),
                            device: devices[index],
                            platform: this.widget.platform,
                          )));
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: devices.length,
      ),
    );
  }

  @override
  void updateDeviceList(Device updatedDevice) {
    int index = 0;
    for (Device device in devices) {
      if (device.key == updatedDevice.key) {
        setState(() {
          devices[index] = updatedDevice;
        });
      }
      index++;
    }
  }

  @override
  void refreshState(List<Device> deviceList) {
    setState(() {
      devices = deviceList;
    });
  }

  Widget showEditIcon(Device device) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        child: Icon(
          Icons.edit,
          color: Colors.blue,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditDevice(
                  presenter: EditDevicePresenter(),
                  device: device,
                  platform: this.widget.platform,
                ),
              ));
        },
      ),
    );
  }

  Widget showDeleteIcon(String key, int index) {
    return GestureDetector(
      child: Icon(
        Icons.delete,
        color: Colors.red,
      ),
      onTap: () {
        this
            .widget
            .presenter
            .deleteDevice(key, index, this.widget.platform, this);
      },
    );
  }

  Widget deleteSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Successful"),
          content: new Text("Data has been successfully deleted."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void removeDevice(int index) {
    devices.removeAt(index);
    deleteSuccessfulDialog();
    refreshState(devices);
  }

  @override
  void dispose() {
    devicesEvent.cancel();
    devicesChangeEvent.cancel();
    super.dispose();
  }
}

class DeviceListView {
  void refreshState(List<Device> deviceList) {}
  void updateDeviceList(Device updatedDevice) {}
  void removeDevice(int index) {}
}
