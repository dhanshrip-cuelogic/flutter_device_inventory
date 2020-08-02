import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceListPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/IssuedDevicePresenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DeviceList.dart';
import 'IssuedDeviceList.dart';

class SelectListPath extends StatefulWidget {
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
      return IssuedDeviceList(presenter: IssuedPresenter());
    } else {
      return DeviceList(presenter: DeviceListPresenter());
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
