import 'package:flutterdeviceinventory/View/RegisterComplaint.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Presenter {
  set setView(RegisterComplaintView value) {}
  void sendMail(String complaint, String name) {}
}

class RegisterComplaintPresenter implements Presenter {
  RegisterComplaintView _view;

  @override
  void set setView(RegisterComplaintView value) {
    _view = value;
  }

  void sendMail(String complaint, String name) async {
    final Email email = Email(
      body: complaint,
      subject: 'Regarding complaint of device - ${name}',
      recipients: ['dhanshri.pawar@cuelogic.com'],
      attachmentPaths: null,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      _view.clearFields();
    } catch (error) {
      _view.showErrorDialog(error);
    }
  }
}
