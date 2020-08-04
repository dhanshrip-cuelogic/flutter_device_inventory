import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/DatabaseManager/DbManager.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceDetailsPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/IssuedDevicePresenter.dart';
import 'package:flutterdeviceinventory/View/DeviceDetails.dart';

class IssuedDeviceView {
  void refreshAvailableList(List<Device> deviceList) {}

  void refreshIssuedList(List<Device> deviceList) {}
  void updateDeviceList(Device device) {}
}

class IssuedDeviceList extends StatefulWidget {
  final IssuedPresenter presenter;
  final platform;

  IssuedDeviceList({this.presenter, this.platform});

  @override
  _IssuedDeviceListState createState() => _IssuedDeviceListState();
}

class _IssuedDeviceListState extends State<IssuedDeviceList>
    implements IssuedDeviceView {
  DbManager _dbManager = DbManager();
  List<Device> availableDevices = [];
  List<Device> issuedDevices = [];

//  List<Device> deviceLists = [];

  @override
  void initState() {
    widget.presenter.setView = this;
    widget.presenter.fetchDevices(this.widget.platform);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    deviceLists.clear();
//    availableDevices.clear();
//    issuedDevices.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text('Issued Devices'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Available Devices'),
            enabled: false,
            leading: Icon(Icons.forward),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(availableDevices[index].deviceName),
                    onTap: () {
                      redirectToDeviceDetails(availableDevices[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: availableDevices.length),
          ),
          ListTile(
            title: Text('Issued Devices'),
            enabled: false,
            leading: Icon(Icons.forward),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(issuedDevices[index].deviceName),
                    onTap: () {
                      redirectToDeviceDetails(issuedDevices[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: issuedDevices.length),
          ),
        ],
      ),
//      FutureBuilder(
//        future: widget.presenter.fetchDevices(this.widget.platform),
//        builder: (context, snapshot) {
//          if (snapshot.connectionState == ConnectionState.none ||
//              snapshot.data == null) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          }
//
//          availableDevices = snapshot.data[0];
//          issuedDevices = snapshot.data[1];
//
//          return Column(
//            children: <Widget>[
//              ListTile(
//                title: Text('Available Devices'),
//                enabled: false,
//                leading: Icon(Icons.forward),
//              ),
//              Expanded(
//                child: ListView.separated(
//                    itemBuilder: (context, index) {
//                      return ListTile(
//                        title: Text(availableDevices[index].deviceName),
//                        onTap: () {
//                          redirectToDeviceDetails(availableDevices[index]);
//                        },
//                      );
//                    },
//                    separatorBuilder: (context, index) => Divider(),
//                    itemCount: availableDevices.length),
//              ),
//              ListTile(
//                title: Text('Issued Devices'),
//                enabled: false,
//                leading: Icon(Icons.forward),
//              ),
//              Expanded(
//                child: ListView.separated(
//                    itemBuilder: (context, index) {
//                      return ListTile(
//                        title: Text(issuedDevices[index].deviceName),
//                        onTap: () {
//                          redirectToDeviceDetails(issuedDevices[index]);
//                        },
//                      );
//                    },
//                    separatorBuilder: (context, index) => Divider(),
//                    itemCount: issuedDevices.length),
//              ),
//            ],
//          );
//        },
//      ),
    );
  }

  void redirectToDeviceDetails(Device device) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DeviceDetails(
                  presenter: DeviceDetailsPresenter(),
                  device: device,
                  platform: this.widget.platform,
                )));
  }

  @override
  void refreshAvailableList(List<Device> deviceList) {
    setState(() {
      availableDevices = deviceList;
    });
  }

  @override
  void refreshIssuedList(List<Device> deviceList) {
    setState(() {
      issuedDevices = deviceList;
    });
  }

  @override
  void updateDeviceList(Device updatedDevice) {
    int index = 0;
    if (updatedDevice.status == "Available") {
      bool gotDevice = false;
      for (Device device in issuedDevices) {
        if (device.key == updatedDevice.key) {
          gotDevice = true;
          break;
        }
        index++;
      }
      if (gotDevice) {
        setState(() {
          issuedDevices.removeAt(index);
          availableDevices.add(updatedDevice);
        });
      }
    } else {
      bool gotDevice = false;
      for (Device device in availableDevices) {
        if (device.key == updatedDevice.key) {
          gotDevice = true;
          break;
        }
        index++;
      }
      if (gotDevice) {
        setState(() {
          availableDevices.removeAt(index);
          issuedDevices.add(updatedDevice);
        });
      }
    }
  }

  @override
  void dispose() {
    this.widget.presenter.presenterDispose();
    super.dispose();
  }
}
