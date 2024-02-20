// TODO: This should be changed! order content is not a list! [ "stocks_x":{x} ]
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String? id;
  Map<String,dynamic>order_content;
  String customer_id;
  Timestamp order_date;
  String state;
  String created_by;
  String warehouse_id;
  String car = "";

  Set<String> requireds =
    {
      "order_content",
      "customer_id",
      "order_date",
      "state",
      "created_by",
      "warehouse_id"
    };
  Set<String> fields=
    {
      "id",
      "order_content",
      "customer_id",
      "order_date",
      "state",
      "created_by",
      "warehouse_id"
      "car"
    };


  Orders(
      {required this.id,
      required this.order_content,
      required this.customer_id,
      required this.order_date,
      required this.state,
      required this.created_by,
      required this.car,
      required this.warehouse_id
      });
  Orders.withOnlyRequireds(
      {
      required this.order_content,
      required this.customer_id,
      required this.order_date,
      required this.state,
      required this.created_by,
      required this.warehouse_id});

  Orders.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        order_content = map["order_content"]!,
        customer_id = map["customer_id"]!,
        order_date = map["order_date"]!,
        state = map["state"]!,
        created_by = map["created_by"]!,
        car = map["car"] ?? "",
        warehouse_id=map["warehouse_id"]!;

  bool isEmpty(){
    return order_content.isEmpty;
  }  

  void addContents(Map<String,dynamic> map){
    order_content.addAll(map);
  }

  void removeContent(String stocks_id){
    order_content.remove(stocks_id);
  }

  // TODO: THIS FUNCTION COULD BE CHANGED
  bool addToContent(List<String> path,int inc){
    
    var value = order_content;
    for (String key in path){
      if (!value.containsKey(key)){
        return false;
      } else if(path.last!=key){
      value = value[key];
      }else{
        value[key] += inc;
        return true;
      }

    }
  return false;
  }

  void updateContent(String key,String newContent){

  }

  Map<String, dynamic> to_Map() {
    return {
      "id": id,
      "order_content": order_content,
      "customer_id": customer_id,
      "order_date": order_date,
      "state": state,
      "created_by": created_by,
      "car": car,
      "warehouse_id":warehouse_id
    };
  }
}
