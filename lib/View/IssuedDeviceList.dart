import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/IssuedDevicePresenter.dart';
import 'package:flutterdeviceinventory/View/DeviceDetails.dart';

class IssuedDeviceView {
  void refreshState(List<Device> availablelist, List<Device> issuedList) {}
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
    );
  }

  @override
  void refreshState(List<Device> availablelist, List<Device> issuedList) {
    setState(() {
      availableDevices = availablelist;
      issuedDevices = issuedList;
    });
  }

  void redirectToDeviceDetails(Device device) {
    Navigator.pushNamed(context, DeviceDetails.routeName, arguments: device);
  }
}
