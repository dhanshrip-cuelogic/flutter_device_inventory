import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/IssuedDevicePresenter.dart';

class IssuedDeviceView {
  void getSortedList() {}

  void refreshState(List<Device> deviceList) {}
}

class IssuedDeviceList extends StatefulWidget {
  final IssuedPresenter presenter;

  IssuedDeviceList({this.presenter});

  @override
  _IssuedDeviceListState createState() => _IssuedDeviceListState();
}

class _IssuedDeviceListState extends State<IssuedDeviceList>
    implements IssuedDeviceView {
  List<Device> availableDevices = [];
  List<Device> issuedDevices = [];

  @override
  void initState() {
    widget.presenter.setView = this;
    widget.presenter.fetchDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    for (var device in availableDevices) {
//      print('------${device.deviceName}-----');
//    }
//
//    for (var device in issuedDevices) {
//      print('------${device.deviceName}-----');
//    }

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
                    title: Text('$index'),
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: 4),
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
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: issuedDevices.length),
          ),
        ],
      ),
    );
  }

  @override
  void getSortedList() {
    print(
        '----------Here is available devices from presenter--------${widget.presenter.availableDevices}-----------');
    print(
        '---------Here is issued devices from presenter---------${widget.presenter.issuedDevices}-----------');
    availableDevices = widget.presenter.availableDevices;
    issuedDevices = widget.presenter.issuedDevices;
//    refreshState();
  }

  @override
  void refreshState(List<Device> deviceList) {
    print('-----------Just for checking.....----------');
    for (var device in deviceList) {
      print('-----------${device.status}----------');
    }
    setState(() {
      issuedDevices = deviceList;
    });

//    List<Device> available = [];
//    List<Device> issued = [];
//    for (var device in deviceList) {
//      print('-----------${device.deviceName}----------');
//      if (device.status == 'Available') {
//        available.add(device);
//      } else {
//        issued.add(device);
//      }
//    }
//    setState(() {
//      availableDevices = available;
//      issuedDevices = issued;
//    });
  }
}
