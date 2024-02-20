import 'package:flutter/material.dart';

class DividerForm extends StatelessWidget {
  const DividerForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Divider(
        height: 30.0,
        color: Colors.grey[300],
      ),
    );
  }
}