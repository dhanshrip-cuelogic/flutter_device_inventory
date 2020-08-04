import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceListPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/IssuedDevicePresenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DeviceList.dart';
import 'IssuedDeviceList.dart';

class SelectListPath extends StatefulWidget {
  final platform;

  SelectListPath({this.platform});

  @override
  _SelectListPathState createState() => _SelectListPathState();
}

class _SelectListPathState extends State<SelectListPath> {
  String user;
  @override
  void initState() {
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user == 'Employee') {
      return IssuedDeviceList(
          presenter: IssuedPresenter(), platform: this.widget.platform);
    } else {
      return DeviceList(
          presenter: DeviceListPresenter(), platform: this.widget.platform);
    }
  }

  void getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fetchedUser = prefs.getString('user');
    setState(() {
      user = fetchedUser;
    });
  }
}
