class Warehouse {
  String? id;
  String city;
  String district = "";
  String chef_id = "";
  List staff_ids = [];
  List car_ids = [];
  List customer_ids = [];
  List order_ids = [];
  List stock_ids = [];
  List category_ids= [];

  Warehouse(
      {required this.id,
      required this.city,
      required this.district,
      required this.chef_id,
      required this.staff_ids,
      required this.car_ids,
      required this.customer_ids,
      required this.stock_ids,
      required this.order_ids,
      required this.category_ids
      });
  Set<String> fields =  {
      "id",
      "city",
      "district",
      "chef_id",
      "staff_ids",
      "car_ids",
      "customer_ids",
      "stock_ids",
      "order_ids",
      "category_ids"
  };

  Set<String> requireds= {
    "city"
  };

  Warehouse.withOnlyRequireds({required this.id, required this.city});

  Warehouse.fromMap(Map<String, dynamic> map)
      : id = map["id"] ,
        city = map["city"],
        district = map["district"] ?? "",
        chef_id = map["chef_id"] ?? "",
        staff_ids = map["staff_ids"] ?? [],
        car_ids = map["car_ids"] ?? [],
        stock_ids = map["stock_ids"] ?? [],
        customer_ids = map["customer_ids"] ?? [],
        order_ids = map["order_ids"]??[],
        category_ids = map["category_ids"]??[];




  Map<String, dynamic> to_Map() {
    return {
      "id": id,
      "city": city,
      "district": district,
      "chef_id": chef_id,
      "staff_ids": staff_ids,
      "car_ids": car_ids,
      "stock_ids": stock_ids,
      "customer_ids":customer_ids,
      "order_ids":order_ids
    };
  }

  void addstocks(String stocks_id){
    stock_ids.add(stocks_id);
  }
  
  void removeStocks(String stocks_id){
    stock_ids.remove(stocks_id);
  }

  void clearstocks(){
    stock_ids.clear();
  }
  
  void addStaff(String staff_id){
    staff_ids.add(staff_id);
  }
  
  void removeStaff(String staff_id){
    staff_ids.remove(staff_id);
  }

  void clearStaffs(){
    staff_ids.clear();
  }


  void addCar(String car_id){
    car_ids.add(car_id);
  }
  
  void removeCar(String car_id){
    car_ids.remove(car_id);
  }

  void clearCars(){
    car_ids.clear();
  }

  void addCustomer(String customer_id){
    customer_ids.add(customer_id);
  }

  void removeCustomer(String customer_id){
    customer_ids.remove(customer_id);
  }
  
  void clearCustomers(){
    customer_ids.clear();
  }

  void addOrder(String order_id){
    order_ids.add(order_id);
  }

  void removeOrder(String order_id){
    order_ids.remove(order_id);
  }
  
  void clearOrders(){
    order_ids.clear();
  }

  void addCategory(String category_id){
    category_ids.add(category_id);
  }

  void removeCategory(String category_id){
    category_ids.remove(category_id);
  }
  
  void clearCategories(){
    category_ids.clear();
  }

}
