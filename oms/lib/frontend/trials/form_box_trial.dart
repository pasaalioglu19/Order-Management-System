import 'package:flutter/material.dart';
import 'package:oms/frontend/components/form_box.dart';

class FormBoxTest extends StatelessWidget {
  final TextEditingController _productNameController1 = TextEditingController();
  final TextEditingController _productNameController2 = TextEditingController();
  final TextEditingController _productNameController3 = TextEditingController();
  FormBoxTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Tüm butonları saran padding
        child: Column(
          children: [
            FormBox(
              controller: _productNameController1, //mandatory attribute
              labelText: 'FormBox 1', //mandatory attribute
              alignment: Alignment.topLeft, //optional attribute
              constraints: const BoxConstraints(maxWidth: 150.0, maxHeight: 80.0), //optional attribute
              margin: const EdgeInsets.symmetric(horizontal: 10.0), //optional attribute
            ),

            const SizedBox(height: 100.0),

            FormBox(
              controller: _productNameController2, //mandatory attribute
              labelText: 'FormBox 2', //mandatory attribute
              alignment: Alignment.center, //optional attribute
              constraints: const BoxConstraints(maxWidth: 200.0, maxHeight: 50.0), //optional attribute
              margin: const EdgeInsets.symmetric(horizontal: 10.0), //optional attribute
            ),

            const SizedBox(height: 100.0),

            FormBox(
              controller: _productNameController3, //mandatory attribute
              labelText: 'FormBox 3', //mandatory attribute
              alignment: Alignment.topRight, //optional attribute
              constraints: const BoxConstraints(maxWidth: 320.0, maxHeight: 40.0), //optional attribute
              margin: const EdgeInsets.symmetric(horizontal: 10.0), //optional attribute
            ),
          ],
        ),
      ),
    );
  }
}

//void main() {
//  runApp(MaterialApp(home: FormBoxTest()));
//}