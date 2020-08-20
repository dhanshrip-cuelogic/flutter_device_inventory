import 'package:flutter/material.dart';

class AlertDialogClass {
  final BuildContext viewContext;

//  final VoidCallback dismissCallback;
//  final VoidCallback okCallback;

  AlertDialogClass(
    this.viewContext,
//    this.dismissCallback,
//    this.okCallback,
  );

  void displayAlertDialog(
      String title,
      String content,
      bool showDismissButton,
      VoidCallback dismissCallback,
      bool showOkButton,
      VoidCallback okCallback) {
    showDialog(
      context: viewContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            okButton(context, showOkButton, okCallback),
            dismissButton(context, showDismissButton, dismissCallback),
          ],
        );
      },
    );
  }

  Widget dismissButton(
      BuildContext context, bool willDisplay, VoidCallback dismissCallback) {
    if (willDisplay == true) {
      return FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
          dismissCallback();
        },
      );
    } else {
      return Container();
    }
  }

  Widget okButton(
      BuildContext context, bool willDisplay, VoidCallback okCallback) {
    if (willDisplay == true) {
      return FlatButton(
        child: Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
          okCallback();
        },
      );
    } else {
      return Container();
    }
  }
}
