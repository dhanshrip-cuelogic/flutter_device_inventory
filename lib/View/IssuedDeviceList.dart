import 'package:flutter/material.dart';
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
  List<Device> availableDevices = [];
  List<Device> issuedDevices = [];
  bool displayIssuedList = false;
  bool displayAvailableList = false;

  @override
  void initState() {
    widget.presenter.setView = this;
    widget.presenter.fetchDevices(this.widget.platform);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Devices'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Available Devices',
                icon: Icon(Icons.phone_iphone),
              ),
              Tab(
                text: 'Issued Devices',
                icon: Icon(Icons.phone_iphone),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            displayAvailableList == true
                ? createAvailableList()
                : Container(child: Center(child: CircularProgressIndicator())),
            displayIssuedList == true
                ? createIssuedList()
                : Container(child: Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }

  Widget createAvailableList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(availableDevices[index].deviceName),
            onTap: () {
              redirectToDeviceDetails(availableDevices[index]);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: availableDevices.length);
  }

  Widget createIssuedList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(issuedDevices[index].deviceName),
            subtitle: Text(issuedDevices[index].checkin),
            trailing: Text(issuedDevices[index].issuedUser),
            onTap: () {
              redirectToDeviceDetails(issuedDevices[index]);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: issuedDevices.length);
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
      displayAvailableList = true;
      availableDevices = deviceList;
    });
  }

  @override
  void refreshIssuedList(List<Device> deviceList) {
    setState(() {
      displayIssuedList = true;
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
