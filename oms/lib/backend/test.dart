import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:oms/backend/api/CarApi.dart';
import 'package:oms/backend/api/OrderApi.dart';
import 'package:oms/backend/api/StockApi.dart';
import 'package:oms/backend/api/StaffApi.dart';
import 'package:oms/backend/api/TableAPIs/TableProduct.dart';
import 'package:oms/backend/api/TableAPIs/TableStock.dart';
import 'package:oms/backend/api/WarehouseApi.dart';
import 'package:oms/backend/models/Car.dart';
import 'package:oms/backend/models/Order.dart';
import 'package:oms/backend/models/Stock.dart';
import 'package:oms/backend/models/Staff.dart';
import 'package:oms/backend/models/Warehouse.dart';

class Tester {
  Tester();
  static Future<bool> test() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    // CAR CONFLICT DETECTION
    // var stocks = firestore.collection("car");
    // CarAPI api = CarAPI();
    // Car c = Car(id: "02ABD02", model: "model", state: "state", orders: []);

    // api.insertCar(c);
    
    // stocks CATEGORY CONTROL
    // var stocks = firestore.collection("stocks");
    // stocksAPI api = stocksAPI();
    // stocks p = stocks.withOnlyRequireds(id: "stocks_idDeneme1", stocks_name: "stocks_nameDeneme", category_id: "Cloth");
    // bool result = await api.insertstocks(p);
    // print(result);

    // ERROR TYPES

    // var c =  Car(id: "02ABC02", model: "model", state: "state", orders: []);
    // var api = CarAPI();
    // var result = await api.insertCar(c);

    // UPDATE car test for order change.
    // var cars = firestore.collection('car');
    // var car = await CarAPI.getOne("02ABC02");
    // await CarAPI.addOrder(car.id,"order_id1"); // OK
    // await CarAPI.removeOrderWithCar(car,"order_id1"); // OK
    // await CarAPI.updateOrder(car.id,["order_id1","order_id2","order_id3"]); // OK need to be controlled if given orders exists
    // print(car.orders);
    // For Orders
    // Orders order = await OrderAPI.getOne("order_id1");
    // await OrderAPI.updateCar(order.id,"02DEF03"); // OK

    // UPDATE DEPENDECIES order and warehouse
    // Warehouse w = await WarehouseAPI.getOne("warehouse_id1");
    // await WarehouseAPI.addStaff(w.id, "staff_id1"); OK
    // var s = await StaffAPI.updateWarehouse("staff_id1","warehouse_id");

    // ORDERED STOCK
    // StockAPI.getSorted("warehouse_id1","category_id"); // OK

    // Stock s = await StockAPI.getOne("product_id1");
    // print(s.category.attributes);
    // print(s.toProductData());

    // var res = await TableStock.getTableContet(5, "Cloth","category_id",  0, "warehouse_id");
    // print(res["stock_id1"]);
    // // print(res["stock_id1"]["content"]["color"]["content"]["red"]);
    // var res2 = await TableProduct.getTableContet(5, "","stock_name",  0, "warehouse_id");
    List<Stock> s = await StockAPI.getAll();
    print(s.length);
    //TODO: content:{name:size,content:{S: false, M: false, L: false}} yapmaya çalışalım
    // print(res2);
    return true;
  }
}
