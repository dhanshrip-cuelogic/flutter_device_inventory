import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Model/DeviceDataModel.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceDetailsPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/RegisterComplaintPresenter.dart';
import 'package:flutterdeviceinventory/View/DeviceHistoryPage.dart';
import 'package:flutterdeviceinventory/View/RegisterComplaint.dart';

class DeviceDetailsView {
  void changeToCheckout({String key}) {}

  void changeToCheckin({String key}) {}
  void changeToIssued({String key}) {}

  void circularIndicator() {}
}

class DeviceDetails extends StatefulWidget {
  final DeviceDetailsPresenter presenter;
  final Device device;
  final platform;

  DeviceDetails({this.presenter, this.device, this.platform});

  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails>
    implements DeviceDetailsView {
  String user = 'Admin';
  Widget button = Container();

  @override
  void initState() {
    button = Container();
    this.widget.presenter.setView = this;
    this
        .widget
        .presenter
        .getuser(this.widget.device.key, this.widget.device.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Device Details'),
            centerTitle: true,
            leading: GestureDetector(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                })),
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

  Widget checkInButton(String key) {
    return RaisedButton(
      color: Colors.green,
      textColor: Colors.white,
      onPressed: () {
        this.widget.presenter.doCheckIn(key, this.widget.platform);
      },
      child: Text('Check-In'),
    );
  }

  Widget issuedButton() {
    return RaisedButton(
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {},
      child: Text('Issued'),
    );
  }

  Widget checkOutButton(String key) {
    return RaisedButton(
      color: Colors.red,
      textColor: Colors.white,
      onPressed: () {
        widget.presenter.doCheckOut(key, this.widget.platform);
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
  void changeToIssued({String key}) {
    setState(() {
      button = issuedButton();
    });
  }

  @override
  void circularIndicator() {
    print('Need to show circular indicator');
    setState(() {
      Center(child: CircularProgressIndicator());
    });
  }

  @override
  void dispose() {
//    this.widget.presenter.presenterDispose();
    super.dispose();
  }
}
