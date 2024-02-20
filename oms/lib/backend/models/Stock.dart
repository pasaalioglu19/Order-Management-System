import 'package:oms/backend/api/CategoryApi.dart';
import 'package:oms/backend/models/Category.dart';

class Stock {
  String? id;
  String stock_name;
  String category_id; // {"size":["S","M","L"]}
  String warehouse_id;
  Category category= Category(id: "",category_name: "", attributes: {},warehouse_id: "");//Base category
  List attributes = [];
  Map<String, dynamic> attribute_map = {}; // {"S":10,"M":0,"L":4}
  final Set<String> fields =   {"id", "stock_name", "category","attribute_map"};
  final Set<String> requireds= {"stock_name"};



  Stock({required this.id, required this.stock_name,required this.category_id,required this.warehouse_id,required this.category}){
    attributes=category.attributes.keys.toList();
    attributes.sort();
    _create_attribute_map();
  }
  
  Stock.withAllFields({required this.id, required this.stock_name,required this.category_id,required this.warehouse_id,required this.category,required this.attribute_map}){
    var temp = category.attributes as Map;
    attributes=temp.keys.toList();
    attributes.sort();
  }

  static Future<Stock> withOnlyRequireds(String id, String stock_name, String category_id,String warehouse_id) async {
        var category = await CategoryAPI.getOne(category_id) ;
        var p = Stock(id: id, stock_name: stock_name, category_id: category_id,warehouse_id: warehouse_id,category: category);
        return p; 
      }

  

  static Future<Stock> fromMap(Map<String, dynamic> map) async{ // This method allows you to create from map. You just need to 
        // Required functions
        Stock p;
        var id = map["id"]!;
        var stock_name = map["stock_name"]!;
        var warehouse_id = map["warehouse_id"]!;
        var category_id = map["category_id"]!; 
        var attribute_map = map["attribute_map"];
        // Getting category.
        var category = await CategoryAPI.getOne(category_id) ;
        if(attribute_map == null){
          p = Stock(id: id, stock_name: stock_name, category_id: category_id,warehouse_id: warehouse_id,category: category);
        }else{
          p =Stock.withAllFields(id: id, stock_name: stock_name, category_id: category_id,warehouse_id: warehouse_id,category: category,attribute_map: attribute_map);
        }

      return p; 
  }


  Map<String, dynamic> to_Map() {
    return {
      "id": id,
      "stock_name": stock_name,
      "category_id": category_id,
      "warehouse_id":warehouse_id,
      "attribute_map": attribute_map
    };
  }

  Map _count_map_creator(int index,List<String> map_keys, Map<String,dynamic> traversal_map){
    // counts map needs to have header of attributes like size,color.
    // List headers = List.from(traversal_map.keys);
    Map counts_map={};
    Map temp_map = {};
    int total = 0;
    // print(traversal_map);
    for(var key in traversal_map.keys){
      if(traversal_map[key] is Map ){
        temp_map[key]={};
        temp_map[key]["content"] = _count_map_creator(index+1,map_keys, traversal_map[key]);
        counts_map[key]=temp_map[key];
       
        total += temp_map[key]["content"][map_keys[index+1]]["row2"] as int;
      }else{
        counts_map[key] = {
          "content": Null,
          "row2":traversal_map[key]
        };
        total += traversal_map[key] as int;
      }

      // total += traversal_map[key] as int;
    }    
    // print(counts_map);
    return { map_keys[index] : {"content":counts_map,"row2":total}};//will be returned something like {"content":Null,"row2":total}
  }

  Map<String,dynamic> toStockData(){
    List<String> map_keys = attributes as List<String>;
    // assign all key headers.
    Map<String,Map<String,int>> totals = {};
    for(var key in map_keys){
      totals[key]={};
    }
    var total={};
    // Find all counts and write them into totals map
    if(map_keys.isNotEmpty){
    total = _count_map_creator(0,map_keys ,Map.from(attribute_map));     
    }

    Map<String,dynamic> m = {
      "name": stock_name,
      "content":total,
      "total":total["row2"]??0
    };
    return m;
  }

  bool _state_map_creator(int index,Map<String,dynamic>states_map,Map<String,dynamic> traversal_map){
    // counts map needs to have header of attributes like size,color.
    List headers = List.from(states_map.keys);
    bool total = false;
    for(var key in traversal_map.keys){
      if(traversal_map[key] is Map ){
        traversal_map[key] = _state_map_creator(index+1, states_map, traversal_map[key]) ? 1:0;
      }
      if(!states_map[headers[index]]["content"]!.containsKey(key)){
        states_map[headers[index]]["content"]![key]={"row2":traversal_map[key] as int > 0,"content":Null};
      }else{
        bool old = states_map[headers[index]]["content"]![key]!["row2"];
        states_map[headers[index]]["content"]![key]["row2"] = old || traversal_map[key] as int > 0 ;
      }


      total |= traversal_map[key] as int > 0;
    }    
    return total;
  }


Map<String,dynamic> toProductData(){
    List<String> map_keys = List<String>.from(category.attributes.keys);
    // assign all key headers.
    Map<String,dynamic> totals = {};
    print(map_keys);
    for(var key in map_keys){
      Map newMap ={};
      newMap["row2"]="Stock Status";
      newMap["content"]={};
      totals[key] = newMap;
    }
    // Find all counts and write them into totals map
    var total = _state_map_creator(0, totals,Map.from(attribute_map));     

    Map<String,dynamic> m = { stock_name: {
      "content":totals,
      "row2":total,
    }};
    return m;
  }

  // This function will create attribute_map
  void _create_attribute_map() {
    attribute_map = _attributer(0,attributes);
  }

  Map<String, dynamic> _attributer(int index,attribute_keys) {
    // attribute_keys = ["size","color"],attribute_map = {"size":["S","M","L"],"color":["green","blue"]}
    if (attribute_keys.isEmpty) {
      return {};
    }
    var specs = category.attributes[attribute_keys.elementAt(index)];

    if (specs == null) {
      return {};
    }

    Map<String, dynamic> result_map = {};
    if (index >= attribute_keys.length - 1) {
      for (var attr in specs) {
        result_map[attr] = 0;
      }
      return result_map;
    }
    for (var attr in specs) {
      result_map[attr] = _attributer(index + 1,attribute_keys);
    }
    return result_map;
  }

  Future<bool> updateCategoryId(String category_id) async{
    var c = await CategoryAPI.getOne(category_id);
    category = c;
    attribute_map.clear();
    _create_attribute_map();
    return true;
  }


}
