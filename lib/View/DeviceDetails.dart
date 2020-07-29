import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Model/UserData.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceDetailsPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/RegisterComplaintPresenter.dart';
import 'package:flutterdeviceinventory/View/DeviceHistoryPage.dart';
import 'package:flutterdeviceinventory/View/RegisterComplaint.dart';

class DeviceDetailsView {
  void changeToCheckout({String key}) {}

  void changeToCheckin({String key}) {}

  void circularIndicator() {}
}

class DeviceDetails extends StatefulWidget {
  static const routeName = '/deviceDetails';
  final DeviceDetailsPresenter presenter;
  final Device device;

  DeviceDetails({this.presenter, this.device});

  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails>
    implements DeviceDetailsView {
  final userData = UserData();
  Widget button;

  @override
  void initState() {
    widget.presenter.setView = this;
    setState(() {
      button = setButton(key: widget.device.key, status: widget.device.status);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Device Details'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              deviceID(widget.device.key),
              deviceName(widget.device.deviceName),
              osVersion(widget.device.osVersion),
              button,
              historyButton(widget.device.key),
              complaintButton(widget.device.deviceName),
            ],
          ),
        ));
  }

  Widget deviceID(String key) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Device ID'),
        ),
        Expanded(
          child: TextFormField(
            enabled: false,
            initialValue: key,
          ),
        )
      ],
    );
  }

  Widget deviceName(String name) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('Device Name'),
        ),
        Expanded(
          child: TextFormField(
            enabled: false,
            initialValue: name,
          ),
        )
      ],
    );
  }

  Widget osVersion(String osVersion) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('OS version'),
        ),
        Expanded(
          child: TextFormField(
            enabled: false,
            initialValue: osVersion,
          ),
        )
      ],
    );
  }

  Widget setButton({String key, String status}) {
    if (userData.user == 'Admin') {
      return Container();
    } else {
      if (status == 'Available') {
        return checkInButton(key);
      } else {
        return checkOutButton(key);
      }
    }
  }

  Widget checkInButton(String key) {
    return RaisedButton(
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () {
        this.widget.presenter.doCheckIn(key);
      },
      child: Text('Check-In'),
    );
  }

  Widget checkOutButton(String key) {
    return RaisedButton(
      color: Colors.red,
      textColor: Colors.white,
      onPressed: () {
        widget.presenter.doCheckOut(key);
      },
      child: Text('Check-Out'),
    );
  }

  Widget historyButton(String key) {
    return RaisedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeviceHistoryPage(
                      deviceKey: key,
                    )));
      },
      child: Text('Device History'),
    );
  }

  Widget complaintButton(String name) {
    return RaisedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterComplaint(
                      presenter: RegisterComplaintPresenter(),
                      name: name,
                    )));
      },
      child: Text('Register Complaint'),
    );
  }

  @override
  void changeToCheckout({String key}) {
    setState(() {
      button = checkOutButton(key);
    });
  }

  @override
  void changeToCheckin({String key}) {
    setState(() {
      button = checkInButton(key);
    });
  }

  @override
  void circularIndicator() {
    print('Need to show circular indicator');
    setState(() {
      Center(child: CircularProgressIndicator());
    });
  }
}
