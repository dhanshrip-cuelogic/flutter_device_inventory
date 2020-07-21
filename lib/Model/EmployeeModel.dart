import 'package:firebase_database/firebase_database.dart';

class Employee {
  String username;
  String email;
  String cueid;

  Employee(this.email, this.cueid, this.username);

  Employee.fromSnapshot(DataSnapshot snapshot)
      : username = snapshot.value["username"],
        email = snapshot.value["email"],
        cueid = snapshot.value["cueid"];

  toJson() {
    return {
      "username": username,
      "email": email,
      "cueid": cueid,
    };
  }
}
