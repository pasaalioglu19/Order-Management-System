class Car {
  String id; // This will be plate number
  String model;
  String state;
  String warehouse_id;
  List<String> orders = [];
  final Set<String> fields= {"id", "model", "state", "orders"};
  final Set<String> requireds= {"id", "model", "state"};
  Car(
      {required this.id,
      required this.model,
      required this.state,
      required this.orders,
      required this.warehouse_id});
  Car.withOnlyRequireds(
      {required this.id, required this.model, required this.state,required this.warehouse_id});

  Car.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        model = map["model"],
        state = map["state"],
        orders = map["orders"] ?? [],
        warehouse_id = map["warehouse_id"];

  void addOrders(List<String> order_ids){
    for(id in order_ids){
      this.orders.add(id);
    }
  }

  void addOrder(String order_id){
    orders.add(order_id);
  }

  bool removeOrder(String order_id){
    return orders.remove(order_id);
  }

  Map<String, dynamic> to_Map() {
    return {
      "id": id,
      "model": model,
      "state": state, 
      "orders": orders,
      "warehouse_id":warehouse_id
    };
  }
}
