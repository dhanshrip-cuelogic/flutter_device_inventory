import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceListPresenter.dart';

class DeviceList extends StatefulWidget {
  final DeviceListPresenter presenter;

  DeviceList({this.presenter});

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> implements DeviceListView {
  List<Device> devices = [];

  @override
  void initState() {
    this.widget.presenter.setView = this;
    this.widget.presenter.fetchDeviceData();
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
              Navigator.pushNamed(context, '/addDevice');
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
              Navigator.pushNamed(context, '/deviceDetails',
                  arguments: devices[index]);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: devices.length,
      ),
    );
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
          Navigator.pushNamed(context, '/editDevice', arguments: device);
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
        this.widget.presenter.deleteDevice(key, index);
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
  void removeDeviceFromList(int index) {
    devices.removeAt(index);
    deleteSuccessfulDialog();
    refreshState(devices);
  }
}

class DeviceListView {
  void refreshState(List<Device> deviceList) {}
  void removeDeviceFromList(int index) {}
}
