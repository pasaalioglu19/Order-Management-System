import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/backend/api/WarehouseApi.dart';
import 'package:oms/backend/api/connections/connections.dart';
import 'package:oms/backend/errors/UpdateErrrors.dart';
import 'package:oms/backend/models/Customer.dart';
import 'package:oms/backend/models/Warehouse.dart';

class CustomerAPI {
  static CollectionReference connection =
      customerConnection;

  CustomerAPI();

// Future<Customer>
  static Future<Customer> getOne(String id) async {
    var snapshot = await connection.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data["id"] = id;
    Customer customer = Customer.fromMap(data);

    return customer;
  }

  static Future<List<Customer>> getSome(int threshold, int limit) async {
    var snapshots = await connection.limit(limit).get();

    List<Customer> customers = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Customer customer = Customer.fromMap(data);
      customers.add(customer);
    }

    return customers;
  }

  static Future<List<Customer>> getAll() async {
    var snapshots = await connection.get();

    List<Customer> customers = [];
    for (QueryDocumentSnapshot snapshot in snapshots.docs) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data["id"] = snapshot.id;
      Customer customer = Customer.fromMap(data);
      customers.add(customer);
    }

    return customers;
  }

  static Future<Map<String,dynamic>> deleteOne(id) async {
    try {
      await connection.doc(id).delete();

      Map<String,dynamic> result = {
        "result":true,
        "info":"Customer successfully deleted!"
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
      Customer c = Customer.fromMap(map);
      map = c.to_Map();
      // id will be generated automatically
      map.remove("id"); 
      await connection.add(map);
      // await doc.set(map);
      
      Map<String,dynamic> result = {
        "result":true,
        "info":"Customer Succesfully Inserted"
      };
      return result;
    
    } catch (e) {
      if( e is FirebaseException ){
        Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantially Customer already exists!",
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

  static Future<Map<String,dynamic>> insertCustomer(Customer customer) async{
    try {
      var map = customer.to_Map();
      // id will be generated automatically
      map.remove("id");
      connection.add(map);

       Map<String,dynamic> result = {
        "result":true,
        "info":"Customer Succesfully Inserted"
      };
      return result;
    } catch (e) {
      if( e is FirebaseException ){
        Map<String,dynamic> result = {
        "result":false,
        "info":"Permission denied. Potantially Customer already exists!",
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

  static Future<Map<String,dynamic>> updateName(String id,String newName) async {
    return await updateOne(id,{"name":newName});
  }

  static Future<Map<String,dynamic>> updateSurame(String id,String newSurname) async {
    return await updateOne(id,{"surname":newSurname});
  }

  static Future<Map<String,dynamic>> updatePhone(String id,String newPhone) async {
    return await updateOne(id,{"phone":newPhone});
  }

  static Future<Map<String,dynamic>> updateCity(String id,String newCity) async {
    return await updateOne(id,{"city":newCity});
  }

  static Future<Map<String,dynamic>> updateDistrict(String id,String newDistrict) async {
    return await updateOne(id,{"district":newDistrict});
  }

  static Future<Map<String,dynamic>> updateNeighbourhood(String id,String newNeighbourhood) async {
    return await updateOne(id,{"neighbourhood":newNeighbourhood});
  }

  static Future<Map<String,dynamic>> updateAdress(String id,String newAdress) async {
    return await updateOne(id,{"adress":newAdress});
  }
  
  static Future<Map<String,dynamic>> updateMapLocation(String id,String newMapLocation) async {
    return await updateOne(id,{"map_location":newMapLocation});
  }
}
