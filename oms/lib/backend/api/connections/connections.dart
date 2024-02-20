import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference carConnection = FirebaseFirestore.instance.collection("car");
CollectionReference categoryConnection = FirebaseFirestore.instance.collection("category");
CollectionReference customerConnection = FirebaseFirestore.instance.collection("customer");
CollectionReference orderConnection = FirebaseFirestore.instance.collection("order");
CollectionReference stocksConnection = FirebaseFirestore.instance.collection("stock");
CollectionReference staffConnection = FirebaseFirestore.instance.collection("staff");
CollectionReference warehouseConnection = FirebaseFirestore.instance.collection("warehouse");
