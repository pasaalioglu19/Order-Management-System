import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/backend/api/OrderApi.dart';
import 'package:oms/backend/api/WarehouseApi.dart';
import 'package:oms/backend/api/connections/connections.dart';
import 'package:oms/backend/errors/UpdateErrrors.dart';
import 'package:oms/backend/models/Car.dart';
import 'package:oms/backend/models/Order.dart';
import 'package:oms/backend/models/Warehouse.dart';


class CarAPI {
  static CollectionReference connection = carConnection;

  CarAPI();

// Future<Car>
  static Future<Car> getOne(String id) async {
    var snapshot = await connection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data["id"] = id;
    data["orders"] = List<String>.from(data["orders"]);
    Car car = Car.fromMap(data);
    return car;
  }

  // static Future<List<Car>> getMany(List<String> car_ids) async{
  //   var cars = await connection;
  // }

  static Future<List<Car>> getSome(int threshold, int limit) async {
    var snapshots = await connection.limit(limit).get();

    List<Car> cars = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Car car = Car.fromMap(data);
      cars.add(car);
    }

    return cars;
  }

  static Future<List<Car>> getAll() async {
    var snapshots = await connection.get();

    List<Car> cars = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Car car = Car.fromMap(data);
      cars.add(car);
    }

    return cars;
  }

  static Future<Map<String,dynamic>> deleteOne(id) async {
    try {
      await connection.doc(id).delete();

      Map<String,dynamic> result = {
        "result":true,
        "info":"Car successfully deleted!"
      };
      return result;
    } catch (e) {
      if( e is FirebaseException ){
        Map<String,dynamic> result = {
        "result":false,
        "info":"Exception from Firebase",
        "error":e
      };
      return result;
      }

      Map<String,dynamic> result = {
        "result":false,
        "info":"Unexpected Behaviour!",
        "error":e
      };
      return result;
    }
  }

  static Future<Map<String,dynamic>> insertWithMap(Map<String, dynamic> map) async {
    try {
      // This is for controlling might be changed
      Car c = Car.fromMap(map);
      map = c.to_Map();
      var doc = connection.doc(map["id"]);
      map.remove("id");
      await doc.set(map);


      Map<String,dynamic> result = {
        "result":true,
        "info":"Car Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
        Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied! Potantially car already exists!",
        "error":e
      };
        return result;
      }
      Map<String,dynamic> result = {
        "result":false,
        "info":"Unexpected Behaviour! Control map keys!",
        "error":e
      };
      return result;
    }
  }

  static Future<Map<String,dynamic>> insertCar(Car car) async{
    try {
      var map = car.to_Map();
      var doc = connection.doc(map["id"]);
      map.remove("id");
      await doc.set(map);


      Map<String,dynamic> result = {
        "result":true,
        "info":"Car Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
        Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied! Potantially car already exists!",
        "error":e
      };
        return result;
      }
      Map<String,dynamic> result = {
        "result":false,
        "info":"Unexpected Behaviour! Control map keys!",
        "error":e
      };
      return result;
    }
  }

  //TODO: This might be changed. There is a class named Stream search it
  static Future<Map<String,dynamic>> updateOne(id, Map<String, dynamic> changes) async {
    Map<String,dynamic> result={};
    if(changes.isEmpty){
      result = {"result":false,"info":"Update object cannot be empty!","error":UpdateEmptyInputError()};
      return result;
    }

    await connection.doc(id).update(changes)
    .then((value) => {
      result["result"]=true,
      result["info"]="Succesfully Updated"
      })
    .catchError((e)=>{
      result["result"]= false,
      result["info"]="Error while updating",
      result["error"]=e.toString()
    });
    return result;

  }

  static Future<Map<String,dynamic>> updateModel(id, String modelName) async {
    Map<String,dynamic> result={};
    if(modelName.isEmpty){
      result = {"result":false,"info":"Update object cannot be empty!","error":UpdateEmptyInputError()};
      return result;
    }

    await connection.doc(id).update({"model":modelName})
    .then((value) => {
      result["result"]=true,
      result["info"]="Succesfully Updated"
      })
    .catchError((e)=>{
      result["result"]= false,
      result["info"]="Error while updating",
      result["error"]=e.toString()
    });
    return result;

  }

  static Future<Map<String,dynamic>> updateState(id, String state) async {
    Map<String,dynamic> result={};
    if(state.isEmpty){
      result = {"result":false,"info":"Update object cannot be empty!","error":UpdateEmptyInputError()};
      return result;
    }

    await connection.doc(id).update({"model":state})
    .then((value) => {
      result["result"]=true,
      result["info"]="Succesfully Updated"
      })
    .catchError((e)=>{
      result["result"]= false,
      result["info"]="Error while updating",
      result["error"]=e.toString()
    });
    return result;

  }
  //Order changes done
  static Future<Map<String,dynamic>> addOrder(String id,String order_id) async {
      Car c  = await getOne(id);
      // Assign to order a car 
      Orders ord = await OrderAPI.getOne(order_id);
      ord.car = c.id;
      OrderAPI.updateOne(ord.id!, {"car":ord.car});
      // Add order to Car 
      c.orders.add(order_id);
      updateOrder(id, c.orders);
      Map<String,dynamic> result = {"result":true,"info":"Order succesfully added!"};
      return result;
  }

  // TODO: Eksiklikler bildiriliyor fakat arada alınan bir hata sonrası önceki commitlerde değişiklikler yapılması gerekebilir!
  static Future<Map<String,dynamic>> updateOrder(String car_id, List<String> order_ids) async {
    // This function will handle all of the cases. you can remove, add and do both with this function. 
    Map<String,dynamic> result={};
    if(order_ids.isEmpty){
      result = {"result":false,"info":"Update object cannot be empty! Use clear order!","error":UpdateEmptyInputError()};
      return result;
    }

    // INFORM ALL ORDERS
    Car c = await CarAPI.getOne(car_id);
    // set of existing orders:
    Set<String> existOrders = Set.from(c.orders);
    // set of added orders :
    Set<String> newOrders =Set.from(order_ids);
    var removedOrders = existOrders.difference(newOrders);
    var addedOrders = newOrders.difference(existOrders);
    // inform all removed
    for (var r in removedOrders) {
      await OrderAPI.updateOne(r, {"car":""});
    }
    // inform all added
    for(var added in addedOrders){
      await OrderAPI.updateOne(added, {"car":c.id});
    }
    // OTHER WON'T BE CHANGED, Change Car's orders list

    await connection.doc(car_id).update({"orders":order_ids})
    .then((value) => {
      result["result"]=true,
      result["info"]="Succesfully Updated"
      })
    .catchError((e)=>{
      result["result"]= false,
      result["info"]="Error while updating",
      result["error"]=e.toString()
    });
    return result;

  }

static Future<Map<String,dynamic>> updateOrderWithCar(Car car, List<String> order_ids) async {
    // This function will handle all of the cases. you can remove, add and do both with this function. 
    Map<String,dynamic> result={};
    if(order_ids.isEmpty){
      result = {"result":false,"info":"Update object cannot be empty! Use clear order!","error":UpdateEmptyInputError()};
      return result;
    }

    // INFORM ALL ORDERS
    // set of existing orders:
    Set<String> existOrders = Set.from(car.orders);
    // set of added orders :
    Set<String> newOrders =Set.from(order_ids);
    var removedOrders = existOrders.difference(newOrders);
    var addedOrders = newOrders.difference(existOrders);
    // inform all removed
    for (var r in removedOrders) {
      await OrderAPI.updateOne(r, {"car":""});
    }
    // inform all added
    for(var added in addedOrders){
      await OrderAPI.updateOne(added, {"car":car.id});
    }
    // OTHER WON'T BE CHANGED, Change Car's orders list

    await connection.doc(car.id).update({"orders":order_ids})
    .then((value) => {
      result["result"]=true,
      result["info"]="Succesfully Updated"
      })
    .catchError((e)=>{
      result["result"]= false,
      result["info"]="Error while updating",
      result["error"]=e.toString()
    });
    return result;

  }

  // Order changes done.
  static Future<Map<String,dynamic>> removeOrder(String car_id,String order_id) async{
    //first remove car from order
    Orders ord = await OrderAPI.getOne(order_id);
    ord.car = "";
    await OrderAPI.updateOne(ord.id!,{"car":ord.car});
    // then remove order from car
    Car c = await getOne(car_id);
    c.removeOrder(order_id);
    return updateOne(car_id,c.to_Map());
  }

  static Future<Map<String,dynamic>> removeOrderWithCar(Car car,String order_id) async{
    //first remove car from order
    Orders ord = await OrderAPI.getOne(order_id);
    ord.car = "";
    await OrderAPI.updateOne(ord.id!,{"car":ord.car});
    // then remove order from car
    
    car.removeOrder(order_id);
    return await updateOne(car.id,car.to_Map());
  }

  static Future<Map<String,dynamic>> clearOrder(String id) async{
    // Inform all orders
    Car c = await getOne(id);
    for(var order_id in c.orders ){
      OrderAPI.updateOne(order_id,{"car":""});
    }
    
    // Remove all orders
    await updateOrder(id,[]);

    Map<String,dynamic> result={
      "result":true,
      "info":"Orders succesfully cleared"
    };

    return result; 
  }

  static Future<Map<String,dynamic>> clearOrderWithCar(Car car) async{
    // Inform all orders
    
    for(var order_id in car.orders ){
      OrderAPI.updateOne(order_id,{"car":""});
    }
    
    // Remove all orders
    await updateOrder(car.id,[]);

    Map<String,dynamic> result={
      "result":true,
      "info":"Orders succesfully cleared"
    };

    return result; 
  }

  static Future<Map<String,dynamic>> updateWarehouse(String id,String newWarehouseId)async {
    // new warehouse
    Warehouse w = await WarehouseAPI.getOne(newWarehouseId);
    w.addCar(id);

    Car c =await CarAPI.getOne(id);
    // remove from older one
    Warehouse w_old = await WarehouseAPI.getOne(c.warehouse_id);
    w_old.removeCar(id);

    c.warehouse_id = newWarehouseId;
    WarehouseAPI.updateOne(w_old.id, {"car_ids":w_old.car_ids});
    WarehouseAPI.updateOne(w.id, {"car_ids":w_old.car_ids});

    return CarAPI.updateOne(c.id, {"warehouse_id":c.warehouse_id});
  }

}
