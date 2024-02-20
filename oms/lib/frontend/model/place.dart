import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderInfo {
  OrderInfo({required this.name, required this.telephone, required this.location});
  String name;
  String telephone;
  LatLng location;
}

class WarehouseInfo {
  WarehouseInfo({required this.id, required this.location});
  String id;
  LatLng location;
}