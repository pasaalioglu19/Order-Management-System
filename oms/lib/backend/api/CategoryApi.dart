import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/backend/api/WarehouseApi.dart';
import 'package:oms/backend/api/connections/connections.dart';
import 'package:oms/backend/errors/UpdateErrrors.dart';
import 'package:oms/backend/models/Category.dart';
import 'package:oms/backend/models/Warehouse.dart';

class CategoryAPI {
  static CollectionReference connection = categoryConnection;
  CategoryAPI();

// Future<Category>
  static Future<Category> getOne(String id) async {
    var snapshot = await connection.doc(id).get();
    var snap_data = snapshot.data();
    Map<String, dynamic> data =snap_data as Map<String, dynamic>;
    data["id"] = id;
    data["attributes"] = Map<String,List>.from(data["attributes"]);
    Category category = Category.fromMap(data);
    return category;
  }

  static Future<List<Category>> getSome(int threshold, int limit) async {
    var snapshots = await connection.limit(limit).get();

    List<Category> categories = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Category category = Category.fromMap(data);
      categories.add(category);
    }

    return categories;
  }

  static Future<List<Category>> getAll() async {
    var snapshots = await connection.get();

    List<Category> categories = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Category category = Category.fromMap(data);
      categories.add(category);
    }

    return categories;
  }

  static Future<Map<String,dynamic>> deleteOne(id) async {
    try {
      await connection.doc(id).delete();

      Map<String,dynamic> result = {
        "result":true,
        "info":"Category successfully deleted!"
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
      Category c = Category.fromMap(map);
      map = c.to_Map();
      var doc = connection.doc(map["id"]);
      map.remove("id");
      await doc.set(map);
    
      Map<String,dynamic> result = {
        "result":true,
        "info":"Category Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
        Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantially Category already exists!",
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

  static Future<Map<String,dynamic>> insertCategory(Category category) async{
    try {
      var map = category.to_Map();
      var doc = connection.doc(map["id"]);
      map.remove("id");
      await doc.set(map);
      
      Map<String,dynamic> result = {
        "result":true,
        "info":"Category Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
        Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantially Category already exists!",
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

  static Future<Map<String,dynamic>> addAttributes(String id,Map<String,List<String>> map) async {
    Category c = await getOne(id);
    c.attributes.addAll(map);
    Map<String,dynamic> logic = await updateOne(c.id,{"attributes":c.attributes});
    return logic;
  }

    static Future<Map<String,dynamic>> updateWarehouse(String id,String newWarehouseId)async {
    // new warehouse
    Warehouse w = await WarehouseAPI.getOne(newWarehouseId);
    w.addCategory(id);

    Category c =await CategoryAPI.getOne(id);
    // remove from older one
    Warehouse w_old = await WarehouseAPI.getOne(c.warehouse_id);
    w_old.removeCategory(id);

    c.warehouse_id = newWarehouseId;
    WarehouseAPI.updateOne(w_old.id, {"order_ids":w_old.order_ids});
    WarehouseAPI.updateOne(w.id, {"order_ids":w_old.order_ids});

    return updateOne(c.id!, {"warehouse_id":c.warehouse_id});
  }

}
