import 'package:flutter/material.dart';
import 'package:oms/Globals/States.dart';

import 'package:oms/frontend/components/styled_button.dart';
import 'package:oms/frontend/components/pop_up.dart'; // Import the custom PopUp
import 'package:oms/frontend/components/form_box.dart'; // Import the custom FormBox

import 'package:oms/backend/api/CarApi.dart';

CarAPI carapi = CarAPI();

class CarPage extends StatefulWidget {
  final String warehouseID;

  const CarPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();

  void _showAddCarPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const PopUpTitle(labelText: 'Add Car'), // Custom popup title
          content: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 5.0), // Horizontal padding for popup
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FormBox(
                    controller: licensePlateController,
                    labelText: 'License Plate',
                    constraints: BoxConstraints(maxWidth: 250),
                  ),
                  SizedBox(height: 10), // Padding between form fields
                  FormBox(
                    controller: carModelController,
                    labelText: 'Car Model',
                    constraints: BoxConstraints(maxWidth: 250),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            StyledButton(
              title: 'Save',
              onPressed: () {
                CarAPI.insertWithMap(<String, String>{
                  'id': licensePlateController.text,
                  'model': carModelController.text,
                  'state': CarStates.inWarehouse,
                  'warehouse_id': widget.warehouseID,
                }).then((result) {
                  if (result['result'] == false) {
                    _showErrorDialog(result['info']);
                  }
                });
                // Resetting the form fields
                licensePlateController.clear();
                carModelController.clear();
                Navigator.of(context).pop(); // Close the popup
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorMessage),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              title: 'Close',
              onPressed: () {
                Navigator.of(context).pop(); // Close the error dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: <Widget>[
            Row(children: [
              StyledButton(
                title: 'Add Car',
                onPressed: _showAddCarPopup, // Open popup on button press
                flex: 1,
              ),
            ]),
            Divider(
              color: Color(0xFFE9E9E9),
              thickness: 1,
            ),
            Expanded(
              child: Center(
                child: Text('CAR PAGE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
