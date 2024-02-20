import 'package:flutter/material.dart';

class SupplyStatusPage extends StatefulWidget {
  final String warehouseID;

  const SupplyStatusPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<SupplyStatusPage> createState() => _SupplyStatusPageState();
}

class _SupplyStatusPageState extends State<SupplyStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('SUPPLY STATUS PAGE'),
      ),
    );
  }
}
