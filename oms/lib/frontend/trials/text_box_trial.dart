import 'package:flutter/material.dart';
import 'package:oms/frontend/components/text_box.dart';

class TextBoxTest extends StatelessWidget {
  const TextBoxTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(8.0), // Tüm butonları saran padding
        child: Column(
          children: [
            TextBox(
              labelText: 'TextBox 1', //mandatory attribute
              alignment: Alignment.topRight, //optional attribute
              fontSize: 15.0, //optional attribute
              constraints: BoxConstraints(maxWidth: 110.0, maxHeight: 30.0), //optional attribute
              margin: EdgeInsets.symmetric(horizontal: 0.0), //optional attribute
            ), 

            SizedBox(height: 100.0),

            TextBox(
              labelText: 'TextBox 2', //mandatory attribute
              alignment: Alignment.center, //optional attribute
              fontSize: 18.0, //optional attribute
              constraints: BoxConstraints(maxWidth: 170.0, maxHeight: 50.0), //optional attribute
              margin: EdgeInsets.symmetric(horizontal: 0.0), //optional attribute
              color: Colors.cyan, //optional attribute
            ), 

            SizedBox(height: 100.0),

            TextBox(
              labelText: 'TextBox 3', //mandatory attribute
              alignment: Alignment.topLeft, //optional attribute
              fontSize: 21.0, //optional attribute
              constraints: BoxConstraints(maxWidth: 230.0, maxHeight: 70.0), //optional attribute
              margin: EdgeInsets.symmetric(horizontal: 0.0), //optional attribute
              color: Colors.amber, //optional attribute
            ), 
          ],
        ),
      ),
    );
  }
}

//void main() {
//  runApp(MaterialApp(home: TextBoxTest()));
//}