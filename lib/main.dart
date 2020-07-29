import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/DeviceDetailsPresenter.dart';
import 'package:flutterdeviceinventory/Presenter/IssuedDevicePresenter.dart';
import 'package:flutterdeviceinventory/View/IssuedDeviceList.dart';
import 'DatabaseManager/DbManager.dart';
import 'Model/DeviceDataModel.dart';
import 'Presenter/AddDevicePresenter.dart';
import 'Presenter/DeviceListPresenter.dart';
import 'Presenter/EditDevicePresenter.dart';
import 'Presenter/PlatformSelectionPresenter.dart';
import 'Presenter/SignUpPresenter.dart';
import 'View/DeviceDetails.dart';
import 'View/DeviceList.dart';
import 'View/RootPage.dart';
import 'View/SignUpPage.dart';
import 'View/AddDevice.dart';
import 'View/EditDevice.dart';
import 'View/PlatformSelectionPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: DbManager()),
      routes: {
        '/signupPage': (BuildContext context) =>
            SignUpPage(presenter: SignUpPresenter()),
        '/platformSelectionPage': (BuildContext context) =>
            PlatformSelectionPage(presenter: PlatformSelectionPresenter()),
        '/deviceList': (BuildContext context) =>
            DeviceList(presenter: DeviceListPresenter()),
        '/addDevice': (BuildContext context) =>
            AddDevice(presenter: AddDevicePresenter()),
        '/editDevice': (BuildContext context) =>
            EditDevice(presenter: EditDevicePresenter()),
        '/issuedDeviceList': (BuildContext context) =>
            IssuedDeviceList(presenter: IssuedPresenter())
      },
      onGenerateRoute: (setting) {
        if (setting.name == DeviceDetails.routeName) {
          final Device device = setting.arguments;
          return MaterialPageRoute(
              builder: (BuildContext context) => DeviceDetails(
                    presenter: DeviceDetailsPresenter(),
                    device: device,
                  ));
        }
      },
    );
  }
}
