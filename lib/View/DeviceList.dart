import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceListPresenter.dart';
import 'package:flutterdeviceinventory/View/DeviceDetails.dart';

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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => DeviceDetails(
                            device: devices[index],
                          ))));
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
}

class DeviceListView {
  void refreshState(List<Device> deviceList) {}
}
