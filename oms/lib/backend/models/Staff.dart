import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  String? id;
  String warehouse_id = '';
  String name;
  String surname;
  String phone;
  String email;
  String password;
  String state;
  String job;
  Timestamp last_seen_time;
  Set<String> fields = {
    "id",
    "name",
    "surname",
    "phone",
    "email",
    "password",
    "state",
    "job",
    "warehouse_id",
    "last_seen_time",
  };

  Set<String> requireds = {
    "name",
    "surname",
    "phone",
    "email",
    "password",
    "state",
    "job",
    "last_seen_time"
  };

  Staff(
      {required this.id,
      required this.warehouse_id,
      required this.name,
      required this.surname,
      required this.phone,
      required this.email,
      required this.password,
      required this.state,
      required this.job,
      required this.last_seen_time});
  Staff.withOnlyRequireds(
      {required this.id,
      required this.name,
      required this.surname,
      required this.phone,
      required this.email,
      required this.password,
      required this.state,
      required this.job,
      required this.last_seen_time});

  Staff.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        surname = map["surname"],
        phone = map["phone"],
        email = map["email"],
        password = map["password"],
        state = map["state"],
        job = map["job"],
        warehouse_id = map["warehouse_id"] ?? "",
        last_seen_time = map["last_seen_time"];

  Map<String, dynamic> to_Map() {
    return {
      "id": id,
      "name": name,
      "surname": surname,
      "phone": phone,
      "email": email,
      "password": password,
      "state": state,
      "job": job,
      "warehouse_id": warehouse_id,
      "last_seen_time": last_seen_time
    };
  }
}
