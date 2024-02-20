import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/backend/api/CategoryApi.dart';
import 'package:oms/backend/api/WarehouseApi.dart';
import 'package:oms/backend/api/connections/connections.dart';
import 'package:oms/backend/errors/UpdateErrrors.dart';
import 'package:oms/backend/models/Category.dart';
import 'package:oms/backend/models/Stock.dart';
import 'package:oms/backend/models/Warehouse.dart';

class StockAPI {
  static CollectionReference connection = stocksConnection;

  StockAPI();

// Future<stocks>
  static Future<Stock> getOne(String id) async {
    var snapshot = await connection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data["id"] = id;
    Stock stocks = await Stock.fromMap(data);
    var att= stocks.attribute_map;
    // print("attributes $att ");
    return stocks;
  }

  // sorted Get Operations This function will be due to warehouse
  static Future<List<Stock>> getSorted(String warehouse_id,String search_by,String value,int pageLength,int pageIndex) async {
    // Orders could be category_id , stocks_name 
    List<Stock> results=[];
    // TODO:This way is not suitable! TODO: second where condition needed to be added
    var snapshot = await connection.where("warehouse_id", isEqualTo:warehouse_id).orderBy("stock_name").get();

    var selected_data = snapshot.docs;//.getRange(pageIndex*pageLength, (pageIndex+1)*pageLength)
    for(var doc in selected_data){
      var data = doc.data() as Map<String,dynamic>;
      data["id"] = doc.id;
      Category c= await CategoryAPI.getOne(data["category_id"]);
      Stock s = Stock.withAllFields(id: data["id"], stock_name: data["stock_name"], category_id:data["category_id"], warehouse_id: data["warehouse_id"], category: c, attribute_map: data["attribute_map"]);
      results.add(s);
    }
  
    return results;
  }

  static Future<int> getNumOfPage(String warehouse_id,String search_by,String value,int pageLength) async {
    // Orders could be category_id , stocks_name 
    List<Stock> results=[];
    var snapshot = connection.where("warehouse_id", isEqualTo:warehouse_id).where(search_by,isEqualTo: value);
    var ordered = snapshot.orderBy("stock_name");
    var result = await ordered.get();

    return result.docs.length;
  }
  

  static Future<List<Stock>> getSome(int threshold, int limit) async {
    var snapshots = await connection.limit(limit).get();

    List<Stock> stocks = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Stock stock = await Stock.fromMap(data);
      stocks.add(stock);
    }

    return stocks;
  }

  static Future<List<Stock>> getAll() async {
    var snapshots = await connection.get();

    List<Stock> stocks = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Stock stock = await Stock.fromMap(data);
      stocks.add(stock);
    }

    return stocks;
  }

  static Future<Map<String,dynamic>> deleteOne(id) async {
    try {
      await connection.doc(id).delete();

      Map<String,dynamic> result = {
        "result":true,
        "info":"stocks successfully deleted!"
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
      Stock p = await Stock.fromMap(map);
      map = p.to_Map();
      // id will be generated from backend
      map.remove("id");
      await connection.add(map);

      Map<String,dynamic> result = {
        "result":true,
        "info":"stocks Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
      Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantial stocks id conflict!",
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

  static Future<Map<String,dynamic>> insertStocks(Stock stocks) async {
    try {
      var map = stocks.to_Map();
      map.remove("id");
      await connection.add(map);

      Map<String,dynamic> result = {
        "result":true,
        "info":"stocks Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
      Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantial stocks id conflict!",
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

  static Future<Map<String,dynamic>> updateStocksName(String id,String stocks_name) async {
    return await updateOne(id,{"stocks_name":stocks_name});
  }

  // TODO: need to be tested!
  static Future<Map<String,dynamic>> updateCategoryId(String id,String category_id) async {
    Stock p = await getOne(id);
    bool result = await p.updateCategoryId(category_id);
    if(!result){
      return {"result":result,"info":"Category ID has NOT been updated"};
    }
    return {"result":result,"info":"Category ID has  been updated"};
  }

  static Future<Map<String,dynamic>> updateWarehouse(String id,String warehouse_id) async {
    Warehouse w = await WarehouseAPI.getOne(warehouse_id);
    w.addstocks(id);


    Stock s = await getOne(id);
    Warehouse w_old = await WarehouseAPI.getOne(s.warehouse_id);
    w_old.removeStocks(s.id!);
    
    WarehouseAPI.updateOne(warehouse_id,{"stock_ids":w.stock_ids});
    WarehouseAPI.updateOne(w_old.id!,{"stock_ids":w_old.stock_ids});

    return updateOne(id,{"warehouse_id":warehouse_id});
  }

}
