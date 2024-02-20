import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/backend/models/Car.dart';
import 'package:oms/backend/models/Category.dart';
import 'package:oms/backend/models/Customer.dart';
import 'package:oms/backend/models/Order.dart';
import 'package:oms/backend/models/Stock.dart';
import 'package:oms/backend/models/Staff.dart';
import 'package:oms/backend/models/Warehouse.dart';
import 'package:oms/Globals/States.dart';

void create_db() async {
  // DATA
  List customer = [
    Customer(
            id: "312312312321",
            name: "Saltuk",
            surname: "Çiftçi",
            phone: "05551223321",
            city: "Adıyaman",
            district: "Kahta",
            adress: "Karşıyaka, Gazi Cd. No:9, 02400 Kâhta/Adıyaman",
            neighbourhood: "Karşıyaka",
            map_location: "37.78774706272233, 38.610721686968446",
            last_order_date: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
    Customer(
            id: "312312312322",
            name: "Ahyet",
            surname: "Urfa",
            phone: "05551223322",
            city: "Malatya",
            district: "Battalgazi",
            adress: "Meydanbaşı, Hötümdede Sk., 44210 Battalgazi/Malatya",
            neighbourhood: "Meydanbaşı",
            map_location: "38.419633612638265, 38.36634182057806",
            last_order_date: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
  ];

  List cars = [
    Car(
        id: "44ABC44",
        model: "Albea",
        state: CarStates.Returning,
        orders: ["order_id"],
        warehouse_id:"warehouse_id").to_Map(),
    Car(
        id: "02ABC02",
        model: "Transit",
        state: CarStates.OnDelivery,
        orders: ["order_id1", "order_id2"],
        warehouse_id:"warehouse_id2").to_Map(),
        
    Car(
        id: "44ABC45",
        model: "Transit",
        state: CarStates.OnDelivery,
        orders: ["order_id4", "order_id5"],
        warehouse_id:"warehouse_id").to_Map(),
    Car(
        id: "02DEF03",
        model: "Ferrari",
        state: CarStates.Loading,
        orders: ["order_id3"],
        warehouse_id:"warehouse_id1").to_Map()
  ];

// TODO: This should be changed! order content is not a list! [ "stocks_x":{x} ]
  List orders = [
    Orders(
            id: "order_id",
            order_content: {
              "product_id1": {
                "S": {"green": 5},
                "M": {"blue": 2}
              },
              "product_id2": {"name": "Selam"}
            },
            customer_id: "customer_id1",
            order_date: Timestamp.fromDate(DateTime.now()),
            state: "Pending",
            created_by: "stuff_id2",
            car: "44ABC44",
            warehouse_id:"warehouse_id")
        .to_Map(),
    Orders(
            id: "order_id1",
            order_content: {
              "product_id1": {
                "S": {"blue": 3},
                "M": {"blue": 2}
              }
            },
            customer_id: "customer_id",
            order_date: Timestamp.fromDate(DateTime.now()),
            state: "TransitOut",
            created_by: "stuff_id1",
            car: "02ABC02",
            warehouse_id:"warehouse_id2")
        .to_Map(),
    Orders(
            id: "order_id2",
            order_content: {
              "product_id1": {
                "S": {"green": 1},
                "M": {"blue": 3}
              },
              "product_id4": {"apple": 23}
            },
            customer_id: "customer_id",
            order_date: Timestamp.fromDate(DateTime.now()),
            state: "Delivery",
            created_by: "stuff_id1",
            car: "02ABC02",
            warehouse_id:"warehouse_id2")
        .to_Map(),
    Orders(
            id: "order_id3",
            order_content: {
              "product_id5": {
                "S": {"green": 5},
                "M": {"blue": 2}
              }
            },
            customer_id: "customer_id",
            order_date: Timestamp.fromDate(DateTime.now()),
            state: "Pending",
            created_by: "stuff_id1",
            car: "02DEF03",
            warehouse_id:"warehouse_id1")
        .to_Map(),
    Orders(
            id: "order_id4",
            order_content: {
              "product_id2": {"title": "Aleyküm Selam"},
              "product_id5": {
                "S": {"green": 5},
                "M": {"blue": 2}
              },
              "product_id1": {
                "S": {"green": 1},
                "M": {"blue": 3}
              }
            },
            customer_id: "customer_id1",
            order_date: Timestamp.fromDate(DateTime.now()),
            state: "Preparing",
            created_by: "stuff_id2",
            car: "44ABC45",
            warehouse_id:"warehouse_id")
        .to_Map(),
    Orders(
            id: "order_id5",
            order_content: {
              "product_id2": {"title": "Selam"}
            },
            customer_id: "customer_id1",
            order_date: Timestamp.fromDate(DateTime.now()),
            state: "Awaiting Confirmation",
            created_by: "stuff_id2",
            car: "44ABC45",
            warehouse_id:"warehouse_id")
        .to_Map()
  ];

// Categories

  List categories = [
    Category(id: "category_id1",category_name: "Cloth", attributes: {
      "size": ["S", "M", "L"],
      "color": ["green", "blue", "red"],
    },warehouse_id: "warehouse_id1").to_Map(),
    Category( id: "category_id2",category_name: "Stationery", attributes: {},warehouse_id: "warehouse_id1").to_Map(),
    Category(id:"category_id3" ,category_name: "Stove", attributes: {
      "size": ["Small", "Medium", "Large"]
    },warehouse_id: "warehouse_id1").to_Map(),
    Category(id:"category_id4" ,category_name: "Juice", attributes: {
      "size": ["Small", "Medium", "Large"],
      "aroma": ["Peach", "Apple"]
    },warehouse_id: "warehouse_id1").to_Map(),
  ];

  List staff = [
    Staff(
            id: "staff_id",
            warehouse_id: "warehouse_id",
            name: "name",
            surname: "surname",
            phone: "phone",
            email: "staff@email.com",
            password: "password",
            state: "Work Day",
            job: "Warehouse Superviser",
            last_seen_time: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
    Staff(
            id: "staff_id1",
            warehouse_id: "warehouse_id1",
            name: "name",
            surname: "surname",
            phone: "phone",
            email: "staff@email.com",
            password: "password",
            state: "Authorized",
            job: "Warehouse Superviser",
            last_seen_time: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
    Staff(
            id: "staff_id2",
            warehouse_id: "warehouse_id",
            name: "name",
            surname: "surname",
            phone: "phone",
            email: "staff@email.com",
            password: "password",
            state: "Work Day",
            job: "Warehouse Superviser",
            last_seen_time: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
    Staff(
            id: "staff_id3",
            warehouse_id: "warehouse_id",
            name: "name",
            surname: "surname",
            phone: "phone",
            email: "staff@email.com",
            password: "password",
            state: "Work Day",
            job: "Driver",
            last_seen_time: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
    Staff(
            id: "staff_id4",
            warehouse_id: "warehouse_id",
            name: "name",
            surname: "surname",
            phone: "phone",
            email: "staff@email.com",
            password: "password",
            state: "Work Day",
            job: "Driver",
            last_seen_time: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
    Staff(
            id: "staff_id5",
            warehouse_id: "warehouse_id",
            name: "name",
            surname: "surname",
            phone: "phone",
            email: "staff@email.com",
            password: "password",
            state: "Work Day",
            job: "Driver",
            last_seen_time: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
    Staff(
            id: "staff_id6",
            warehouse_id: "warehouse_id",
            name: "name",
            surname: "surname",
            phone: "phone",
            email: "staff@email.com",
            password: "password",
            state: "Work Day",
            job: "Driver",
            last_seen_time: Timestamp.fromDate(DateTime.now()))
        .to_Map(),
  ];
  List warehouses = [
    Warehouse(
        id: "warehouse_id",
        city: "Malatya",
        district: "Battalgazi",
        chef_id: "chef_id",
        staff_ids: ["stuff_id", "stuff_id1", "stuff_id2"],
        car_ids: ["car_id"],
        stock_ids: ["porduct_id"],
        customer_ids: [],
        order_ids: [],
        category_ids: []).to_Map(),
    Warehouse(
        id: "warehouse_id1",
        city: "Adıyaman",
        district: "Kahta",
        chef_id: "chef_id",
        staff_ids: ["stuff_id3", "stuff_id4"],
        car_ids: ["car_id"],
        stock_ids: ["porduct_id"],
        customer_ids: [],
        order_ids: [],
        category_ids: []
        ).to_Map(),
    Warehouse(
        id: "warehouse_id2",
        city: "Malatya",
        district: "Merkez",
        chef_id: "chef_id",
        staff_ids: ["stuff_id5", "stuff_id6", "stuff_id7", "stuff_id8"],
        car_ids: ["car_id"],
        stock_ids: ["porduct_id"],
        customer_ids: [],
        order_ids: [],
        category_ids: []).to_Map()
  ];

  List<String> collections = [
    // "warehouse",
    // "category",
    // "customer",
    // "car",
    // "order",
    // "staff"
    
  ];

  Map<String, dynamic> sample_map = {
    // "category":categories,
    // "customer": customer,
    // "car": cars,
    // "order": orders,
    // "staff": staff,
    // "warehouse": warehouses
  };

  FirebaseFirestore connector = FirebaseFirestore.instance;
  // Creating collections. and adding dummy variales.
  for (String samples in collections) {
    for (dynamic sample in sample_map[samples]) {
      var collection = connector.collection(samples);
      var named_document = collection.doc(sample["id"]);
      sample.remove("id");
      await named_document.set(sample);
    }
  }

  // stocks maps This part came after Categories added.
  Map<String, dynamic> p = {
    "id": "stock_id5",
    "stock_name": "Coat",
    "category_id": "Cloth",
    "warehouse_id":"warehouse_id1"
  };
  Map<String, dynamic> p1 = {
    "id": "stock_id1",
    "stock_name": "T-shirt",
    "category_id": "Cloth",
    "warehouse_id":"warehouse_id",

  };
  Map<String, dynamic> p2 = {
    "id": "stock_id2",
    "stock_name": "Book",
    "category_id": "Stationery",
    "warehouse_id":"warehouse_id"
  };
  Map<String, dynamic> p3 = {
    "id": "stock_id3",
    "stock_name": "Elektric Stove",
    "category_id": "Stove",
    "warehouse_id":"warehouse_id2"
  };
  Map<String, dynamic> p4 = {
    "id": "stock_id4",
    "stock_name": "Fruit Juice",
    "category_id": "Juice",
    "warehouse_id":"warehouse_id1"
  };
  Stock pr = await Stock.withOnlyRequireds(p["id"], p["stock_name"], p["category_id"], p["warehouse_id"]);
  Stock pr1 = await Stock.withOnlyRequireds(p1["id"], p1["stock_name"], p1["category_id"], p1["warehouse_id"]);
  Stock pr2 = await Stock.withOnlyRequireds(p2["id"], p2["stock_name"], p2["category_id"], p2["warehouse_id"]);
  Stock pr3 = await Stock.withOnlyRequireds(p3["id"], p3["stock_name"], p3["category_id"], p3["warehouse_id"]);
  Stock pr4 = await Stock.withOnlyRequireds(p4["id"], p4["stock_name"], p4["category_id"], p4["warehouse_id"]);
  // Stock pr1 = await Stock.fromMap(p1);
  // Stock pr2 = await Stock.fromMap(p2);
  // Stock pr3 = await Stock.fromMap(p3);
  // Stock pr4 = await Stock.fromMap(p4);
  List stocks = [
    pr.to_Map(),
    pr1.to_Map(),
    pr2.to_Map(),
    pr3.to_Map(),
    pr4.to_Map()
  ];

  for (dynamic sample in stocks) {
      var collection = connector.collection("stock");
      var named_document = collection.doc(sample["id"]);
      sample.remove("id");
      await named_document.set(sample);
    }
}

