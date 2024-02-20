import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/backend/api/CarApi.dart';
import 'package:oms/backend/api/WarehouseApi.dart';
import 'package:oms/backend/api/connections/connections.dart';
import 'package:oms/backend/errors/UpdateErrrors.dart';
import 'package:oms/backend/models/Car.dart';
import 'package:oms/backend/models/Order.dart';
import 'package:oms/backend/models/Warehouse.dart';


class OrderAPI {
  static CollectionReference connection =
      orderConnection;

  OrderAPI();

// Future<Orders>
  static Future<Orders> getOne(String id) async {
    var snapshot = await connection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data["id"] = id;
    Orders order = Orders.fromMap(data);
    return order;
  }

  // sorted Get Operations This function will be due to warehouse
  static Future<List<Orders>> getSorted(String warehouse_id,order_by) async {
    // Orders could be category_id , stocks_name 
    List<Orders> results=[];
    var snapshot = await connection.where("warehouse_id", isEqualTo:warehouse_id).orderBy("category_id").get();
    for(var doc in snapshot.docs){
      Orders s = await Orders.fromMap(Map<String,dynamic>.from(doc.data() as Map<String,dynamic>));
      results.add(s);
    }
  
    return results;
  }

  static Future<List<Orders>> getSome(int threshold, int limit) async {
    var snapshots = await connection.limit(limit).get();

    List<Orders> orders = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Orders order = Orders.fromMap(data);
      orders.add(order);
    }

    return orders;
  }

  static Future<List<Orders>> getAll() async {
    var snapshots = await connection.get();

    List<Orders> orders = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Orders order = Orders.fromMap(data);
      orders.add(order);
    }

    return orders;
  }

  static Future<List<Orders>> getOrdersByField({String? warehouse_id, String? fieldName, dynamic fieldValue}) async {
  Query query = connection;
  
  if (fieldName != null && fieldValue != null && warehouse_id != null) {
    query = query.where('warehouse_id', isEqualTo: warehouse_id).where(fieldName, isEqualTo: fieldValue);
  }

  var snapshots = await query.get();

  List<Orders> orders = [];
  for (QueryDocumentSnapshot snapshot in snapshots.docs) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data["id"] = snapshot.id;
    Orders order = Orders.fromMap(data);
    orders.add(order);
  }

  return orders;
}


  static Future<Map<String,dynamic>> deleteOne(id) async {
    try {
      await connection.doc(id).delete();

      Map<String,dynamic> result = {
        "result":true,
        "info":"Order successfully deleted!"
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

  static Future<Map<String,dynamic>> insertWithMap(Map<String, dynamic> map) async{
    try {
      // This is for controlling might be changed
      Orders o = Orders.fromMap(map);
      map = o.to_Map();
      // id will be generated automatically
      map.remove("id");
      await connection.add(map);

      Map<String,dynamic> result = {
        "result":true,
        "info":"Order Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
      Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Creator might not be permitted or controll customer and car exists!",
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

  static Future<Map<String,dynamic>> insertOrder(Orders order) async{
    try {
      var map = order.to_Map();
      // id will be generated automatically
      map.remove("id");
      await connection.add(map);

      Map<String,dynamic> result = {
        "result":true,
        "info":"Order Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
      Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Creator might not be permitted or controll customer and car exists!",
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
  static Future<Map<String,dynamic>> updateOne(String id, Map<String, dynamic> changes) async {
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

  static Future<Map<String,dynamic>> updateContent(String id,Map<String,dynamic> stocks_ids) async {
    return await updateOne(id,{"order_content":stocks_ids});
  }

  static Future<Map<String,dynamic>> addContent(String id,Map<String,dynamic>  stocks_id) async {
    Orders ord = await getOne(id);
    ord.addContents(stocks_id);
    return await updateContent(id,ord.order_content);
  }

  static Future<Map<String,dynamic>> removeContent(String id,String stocks_id) async {
    Orders ord = await getOne(id);
    ord.removeContent(stocks_id);
    return await updateContent(id,ord.order_content);
  }

  static Future<Map<String,dynamic>> updateCustomer(String id,String customer_id) async {
    return await updateOne(id,{"customer_id":customer_id});
  }

  static Future<Map<String,dynamic>> updateState(String id,String state) async {
    return await updateOne(id,{"state":state});
  }

  static Future<Map<String,dynamic>> updateCreator(String id,String creator_id) async {
    return await updateOne(id,{"created_by":creator_id}); // Controlling creator is made from backend
  }

  static Future<Map<String,dynamic>> updateWarehouse(String id,String newWarehouseId)async {
    // new warehouse
    Warehouse w = await WarehouseAPI.getOne(newWarehouseId);
    w.addCar(id);

    Orders c =await OrderAPI.getOne(id);
    // remove from older one
    Warehouse w_old = await WarehouseAPI.getOne(c.warehouse_id);
    w_old.removeOrder(id);
    
    c.warehouse_id = newWarehouseId;
    WarehouseAPI.updateOne(w_old.id, {"order_ids":w_old.order_ids});
    WarehouseAPI.updateOne(w.id, {"order_ids":w_old.order_ids});

    return OrderAPI.updateOne(c.id!, {"warehouse_id":c.warehouse_id});
  }


  static Future<Map<String,dynamic>> updateCar(String id,String car_id) async {
    Orders ord =  await getOne(id);
    // Remove Order from car
    Car c = await CarAPI.getOne(ord.car);
    // ! will throw an exception if id isn't send
    c.removeOrder(ord.id!);
    await CarAPI.updateOne(c.id,{"orders":c.orders});
    // update new car's orders
    c = await CarAPI.getOne(ord.car);
    c.addOrder(ord.id!);
    await CarAPI.updateOne(c.id,{"orders":c.orders});
    // update car at Order
    return await updateOne(id,{"car":car_id});
  }

  static Future<Map<String,dynamic>> updateCarWithOrder(Orders ord,String car_id) async {
    //  Remove Order from car
    Car c = await CarAPI.getOne(ord.car);
    c.removeOrder(ord.id!);
    await CarAPI.updateOne(c.id,{"orders":c.orders});
    // update car at Order
    return await updateOne(ord.id!,{"car":car_id});
  }

}
