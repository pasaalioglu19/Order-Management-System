import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/backend/api/CarApi.dart';
import 'package:oms/backend/api/CategoryApi.dart';
import 'package:oms/backend/api/OrderApi.dart';
import 'package:oms/backend/api/StaffApi.dart';
import 'package:oms/backend/api/StockApi.dart';
import 'package:oms/backend/api/connections/connections.dart';
import 'package:oms/backend/errors/UpdateErrrors.dart';
import 'package:oms/backend/models/Staff.dart';
import 'package:oms/backend/models/Stock.dart';
import 'package:oms/backend/models/Warehouse.dart';

class WarehouseAPI {
  static CollectionReference connection = warehouseConnection;

// Future<Warehouse>
  static Future<Warehouse> getOne(String id) async {
    // if (warehouse_id == "") return ; TODO: control this
    var snapshot = await connection.doc(id).get();
    Map<String, dynamic> data =  snapshot.data() as Map<String, dynamic>;
    data["id"] = id;
    Warehouse w = Warehouse.fromMap(data);
    return w;
  }

  // static Future<List<Stock>> getWarehouseStock(String id){
    
  // }

  static Future<List<Warehouse>> getSome(int threshold, int limit) async {
    var snapshots = await connection.limit(limit).get();

    List<Warehouse> warehouses = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Warehouse warehouse = Warehouse.fromMap(data);
      warehouses.add(warehouse);
    }

    return warehouses;
  }

  static Future<List<Warehouse>> getAll() async {
    var snapshots = await connection.get();

    List<Warehouse> warehouses = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Warehouse warehouse = Warehouse.fromMap(data);
      warehouses.add(warehouse);
    }

    return warehouses;
  }

  static Future<Map<String,dynamic>> deleteOne(warehouse_id) async {
    if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

    try {
      await connection.doc(warehouse_id).delete();

      Map<String,dynamic> result = {
        "result":true,
        "info":"Warehouse successfully deleted!"
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
      Warehouse w = Warehouse.fromMap(map);
      map = w.to_Map();
      // id will be asigned from backend
      map.remove("id");
      await connection.add(map);

      Map<String,dynamic> result = {
        "result":true,
        "info":"Warehouse Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
      Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantial Warehouse id conflict!",
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

// Need to change! if id sended, document's name needs to be id!
  static Future<Map<String,dynamic>> insertWarehouse(Warehouse warehouse) async {
    try {
      var map = warehouse.to_Map();
      // Id will be assigned from database
      map.remove("id");
      await connection.add(map);

      Map<String,dynamic> result = {
        "result":true,
        "info":"Warehouse Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
      Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantial Warehouse id conflict!",
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
  static Future<Map<String,dynamic>> updateOne(warehouse_id, Map<String, dynamic> changes) async {
    if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

    Map<String,dynamic> result={};
    if(changes.isEmpty){
      result = {"result":false,"info":"Update object cannot be empty!","error":UpdateEmptyInputError()};
      return result;
    }
    // remove if id sended
    changes["id"] ?? changes.remove("id");

    await connection.doc(warehouse_id).update(changes)
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

  static Future<Map<String,dynamic>> updateCity(String warehouse_id,String city) async {
    if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

    return await updateOne(warehouse_id,{"city":city});
  }

  static Future<Map<String,dynamic>> updateDistrict(String warehouse_id,String district) async {
    if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

    return await updateOne(warehouse_id,{"district":district});
  }
  
  static Future<Map<String,dynamic>> updateChef(String warehouse_id,String chef_id) async {
    if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

    return await updateOne(warehouse_id,{"chef_id":chef_id});
  }

  static Future<Map<String,dynamic>> createUser(String warehouse_id,Map<String,dynamic> staff_map_contructor) async {
    if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

    // Creating Staff first
    Staff s = Staff.fromMap(staff_map_contructor);
    s.warehouse_id = warehouse_id;
    await StaffAPI.insertStaff(s);

    // Adding to the staffs
    Warehouse w = await getOne(warehouse_id);
    w.addStaff(s.id!);
    return await updateOne(warehouse_id, {"staff_ids":w.staff_ids});

  }

  static Future<Map<String,dynamic>> addStaff(String warehouse_id,String staff_id) async {
    // This Function for Already existing staffs!
    if (warehouse_id == "" || staff_id == "") return {"result":false,"info":"Please sent acceptable Ids"};
    await StaffAPI.updateOne(staff_id, {"warehouse_id":warehouse_id});

    Warehouse w = await getOne(warehouse_id);
    w.addStaff(staff_id);
    return await updateOne(warehouse_id,{"staff_ids":w.staff_ids});
  }

  static Future<Map<String,dynamic>> removeStaff(String warehouse_id,String staff_id) async {
    if (warehouse_id == "" || staff_id == "") return {"result":false,"info":"Please sent acceptable Ids"};
    // Inform Staff
    StaffAPI.updateOne(staff_id,{"warehouse":""});

    Warehouse w = await getOne(staff_id);
    w.removeStaff(staff_id);
    return await updateOne(warehouse_id,{"staff_ids":w.staff_ids});
  }

  // CLEAR FUNCTIONS WON'T BE USED FOR NOW
  // static Future<Map<String,dynamic>> clearStaff(String warehouse_id) async {
  //   if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

  //   return await updateOne(warehouse_id,{"staff_ids":[]});
  // }

  static Future<Map<String,dynamic>> addCar(String warehouse_id,String car_id) async {
    if (warehouse_id == ""||car_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    CarAPI.updateOne(car_id, {"warehouse_id":warehouse_id});

    Warehouse w = await getOne(car_id);
    w.addCar(car_id);
    return await updateOne(warehouse_id,{"car_ids":w.car_ids});
  }

  static Future<Map<String,dynamic>> removeCar(String warehouse_id,String car_id) async {
    if (warehouse_id == ""||car_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    CarAPI.deleteOne(car_id); // this means delete order

    
    Warehouse w = await getOne(car_id);
    w.removeCar(car_id);
    return await updateOne(warehouse_id,{"car_ids":w.car_ids});
  }

  // static Future<Map<String,dynamic>> clearCar(String warehouse_id) async {
  //   if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

  //   return await updateOne(warehouse_id,{"car_ids":[]});
  // }

  static Future<Map<String,dynamic>> addStock(String warehouse_id,String stock_id) async {
    if (warehouse_id == ""||stock_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    StockAPI.updateOne(stock_id, {"warehouse_id":warehouse_id});


    Warehouse w = await getOne(stock_id);
    w.addstocks(stock_id); // This function will take stocks_id and adds it's stocks.
    return await updateOne(warehouse_id,{"stocks_ids":w.stock_ids});
  }

  static Future<Map<String,dynamic>> removeStock(String warehouse_id,String stocks_id) async {
    if (warehouse_id == ""||stocks_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    StockAPI.deleteOne(stocks_id); // this means delete order


    Warehouse w = await getOne(stocks_id);
    w.removeStocks(stocks_id);
    return await updateOne(warehouse_id,{"stocks_ids":w.stock_ids});
  }

  // static Future<Map<String,dynamic>> clearStocks(String warehouse_id) async {
  //   if (warehouse_id == "") return {"result":false,"info":"Please sent acceptable Ids"};

  //   for

  //   return await updateOne(warehouse_id,{"stocks":[]});
  // }

    static Future<Map<String,dynamic>> addOrder(String warehouse_id,String order_id) async {
    if (warehouse_id == ""||order_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    OrderAPI.updateOne(order_id, {"warehouse_id":warehouse_id});

    Warehouse w = await getOne(order_id);
    w.addOrder(order_id); // This function will take order_id and adds it's stocks.
    return await updateOne(warehouse_id,{"order_ids":w.order_ids});
  }

  static Future<Map<String,dynamic>> removeOrder(String warehouse_id,String order_id) async {
    if (warehouse_id == ""||order_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    OrderAPI.deleteOne(order_id); // this means delete order

    Warehouse w = await getOne(order_id);
    w.removeStocks(order_id);
    return await updateOne(warehouse_id,{"order_ids":w.order_ids});
  }

    static Future<Map<String,dynamic>> addCategory(String warehouse_id,String category_id) async {
    if (warehouse_id == ""||category_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    CategoryAPI.updateOne(category_id, {"warehouse_id":warehouse_id});

    Warehouse w = await getOne(category_id);
    w.addCategory(category_id); // This function will take category_id and adds it's stocks.
    return await updateOne(warehouse_id,{"category_ids":w.category_ids});
  }

  static Future<Map<String,dynamic>> removeCategory(String warehouse_id,String category_id) async {
    if (warehouse_id == ""||category_id=="") return {"result":false,"info":"Please sent acceptable Ids"};

    CategoryAPI.deleteOne(category_id); // this means delete order

    Warehouse w = await getOne(category_id);
    w.removeStocks(category_id);
    return await updateOne(warehouse_id,{"category_ids":w.category_ids});
  }

}
