import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oms/backend/api/StaffApi.dart';
import 'package:oms/backend/creating.dart';
import 'package:oms/backend/test.dart';
import 'package:oms/frontend/on_board.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCr5kx6AXlISpZX68T5KlVgT7Dl2h942-k",
          appId: "1:148020391959:android:62cbc8912de2641e00ac52",
          messagingSenderId: "148020391959",
          projectId: "order-management-system-c44e2"));

  await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: const FirebaseOptions(
          apiKey: "AIzaSyCr5kx6AXlISpZX68T5KlVgT7Dl2h942-k",
          appId: "1:148020391959:android:62cbc8912de2641e00ac52",
          messagingSenderId: "148020391959",
          projectId: "order-management-system-c44e2"));

  // create_db();
  Tester.test();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Management System',
      theme: ThemeData(
        textTheme: GoogleFonts.niramitTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const OnBoardWidget(),
    );
  }
}
