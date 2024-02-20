import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oms/frontend/components/orders_map.dart';
import 'package:oms/frontend/model/place.dart';

class mapTrial extends StatelessWidget {
  WarehouseInfo firstWareHouse =
      WarehouseInfo(id: "1", location: LatLng(38.342339, 38.189661));
  Map<String, OrderInfo> ordersFromId = {
    "2": OrderInfo(
        name: "Halil Cibran",
        telephone: "540397",
        location: LatLng(38.344513, 38.185679)),
    "1": OrderInfo(
        name: "Ahyet Emmi",
        telephone: "539398",
        location: LatLng(38.344412, 38.187677)),
    "3": OrderInfo(
        name: "Yusuf Emmi",
        telephone: "539395",
        location: LatLng(38.347412, 38.181677)),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: OrdersMap(
        warehouse: firstWareHouse,
        ordersFromId: ordersFromId,
      )),
    );
  }
}


//çalıştırmak için aşağıdaki kodu kopyalayabilirsiniz
// void main() => runApp(mapTrial());