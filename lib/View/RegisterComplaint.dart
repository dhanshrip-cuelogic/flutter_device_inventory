import 'package:flutter/material.dart';
import 'package:flutterdeviceinventory/Presenter/RegisterComplaintPresenter.dart';

import 'AlertDialogClass.dart';

class RegisterComplaintView {
  void clearFields() {}

  void showErrorDialog(Error error) {}
}

class RegisterComplaint extends StatefulWidget {
  final RegisterComplaintPresenter presenter;
  final String name;

  RegisterComplaint({this.presenter, this.name});

  @override
  _RegisterComplaintState createState() => _RegisterComplaintState();
}

class _RegisterComplaintState extends State<RegisterComplaint>
    implements RegisterComplaintView {
  TextEditingController _commmentController = TextEditingController();
  AlertDialogClass alertDialogClass;

  @override
  void initState() {
    widget.presenter.setView = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    alertDialogClass = AlertDialogClass(context);
    return Scaffold(
      appBar: AppBar(title: Text('Send mail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Container(
                height: 200.0,
                width: 350.0,
                color: Colors.black12,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextField(
                    controller: _commmentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter complaint',
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                widget.presenter
                    .sendMail(_commmentController.text, widget.name);
              },
              child: Text('Send Complaint'),
            )
          ],
        ),
      ),
    );
  }

  void showErrorDialog(Error error) {
    alertDialogClass.displayAlertDialog(
        "Verify your account",
        "Please verify account in the link sent to email",
        true,
        () {},
        false,
        () {});
  }

  @override
  void clearFields() {
    setState(() {
      _commmentController.text = "";
    });
  }

  @override
  void dispose() {
    _commmentController.dispose();
    super.dispose();
  }
}
