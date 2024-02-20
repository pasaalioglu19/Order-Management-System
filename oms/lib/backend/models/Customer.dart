import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String? id;
  String name;
  String surname;
  String phone;
  String city;
  String district;
  String neighbourhood;
  String adress;
  String? map_location;
  // TODO: Order vermemiş olabilir.
  Timestamp last_order_date;
  Set<String> requireds = {
    "name",
    "surname",
    "phone",
    "city",
    "district",
    "neighbourhood",
    "adress",
    "last_order_date"
  };

  Set<String> fields = {
    "id",
    "name",
    "surname",
    "phone",
    "city",
    "district",
    "neighbourhood",
    "adress",
    "map_location",
    "last_order_date"
  };

  Customer(
      {required this.id,
      required this.name,
      required this.surname,
      required this.phone,
      required this.city,
      required this.district,
      required this.adress,
      required this.neighbourhood,
      required this.map_location,
      required this.last_order_date});

  Customer.withOnlyRequireds(
      {
      required this.name,
      required this.surname,
      required this.phone,
      required this.city,
      required this.district,
      required this.adress,
      required this.neighbourhood,
      required this.last_order_date});

  Customer.fromMap(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"]!,
        surname = data["surname"]!,
        phone = data["phone"]!,
        city = data["city"]!,
        district = data["district"]!,
        adress = data["adress"]!,
        neighbourhood = data["neighbourhood"]!,
        last_order_date = data["last_order_date"]!,
        map_location = data["map_location"]!
        ;

  Map<String, dynamic> to_Map() {
    return {
      "id": id,
      "name": name,
      "surname": surname,
      "phone": phone,
      "city": city,
      "district": district,
      "neighbourhood": neighbourhood,
      "adress": adress,
      "map_location": map_location,
      "last_order_date": last_order_date,
      };
  }
}
