class Category {
  String id;// id will be category name.
  String category_name;
  Map<String,List> attributes={};
  String warehouse_id;
  final Set<String> fields = {"id", "name", "attributes"};
  final Set<String> requireds = {"name"};
  

  Category(
      {required this.id,
      required this.warehouse_id,
      required this.category_name,
      required this.attributes});
  Category.withOnlyRequireds(
      {required this.id,required this.category_name,required this.warehouse_id});

  Category.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        attributes = map["attributes"] as Map<String,List>,
        warehouse_id=map["warehouse_id"],
        category_name=map["category_name"];

  bool addAttributes(Map<String,dynamic> newAttributes){
    // Example {"size":["XS","S"...],"color":["green"]}
    bool result = false;
    for(String key in newAttributes.keys){
      if(!attributes.containsKey(key)){
        attributes[key] = newAttributes[key];
      }
      result= addAttributesToFeature(key, newAttributes[key]);
    }
    return result;
  }

  bool addAttributesToFeature(String feature,List<String> newAttributes){
    List exists = attributes[feature]!;
    var diffs = newAttributes.toSet().difference(exists.toSet());
    if (diffs.isNotEmpty) {
      attributes[feature]=newAttributes..addAll(exists as List<String>);
    }
    return true;
  }

  bool removeAttributes(Map<String,dynamic> removedAttributes){
    bool result = false;
    for(String key in removedAttributes.keys){
      if(!attributes.containsKey(key)){
        return false;
      }
      result= removeAttributesFromFeature(key, removedAttributes[key]);
    }
    return result;
  }

  bool removeAttributesFromFeature(String feature,List<String> removedAttributes){
    List exists = attributes[feature]!;
    var intersects = removedAttributes.toSet().intersection(exists.toSet());
    if (!intersects.isNotEmpty) {
      
      for (var value in intersects)
        attributes.remove(value);
    return true;
    }
    return false;
  }

  Map<String, dynamic> to_Map() {
    return {
      "id": id,
      "attributes": attributes, //@ is used for private variables    };
  };
}
}