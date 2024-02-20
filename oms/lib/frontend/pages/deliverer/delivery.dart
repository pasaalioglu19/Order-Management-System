import 'package:flutter/material.dart';

class DeliveryPage extends StatefulWidget {
  final String warehouseID;

  const DeliveryPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('DELIVERY PAGE'),
      ),
    );
  }
}
