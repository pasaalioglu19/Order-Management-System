import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final String warehouseID;

  const OrderPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('ORDER PAGE'),
      ),
    );
  }
}
