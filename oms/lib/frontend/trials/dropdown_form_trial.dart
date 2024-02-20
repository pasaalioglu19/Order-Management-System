import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:oms/frontend/components/dropdown_form.dart';

class DropDownFormTest extends StatelessWidget {
  final List<DropDownValueModel> exampleDropDownList = [
    DropDownValueModel(name: 'Item 1', value: 'Value 1'),
    DropDownValueModel(name: 'Item 2', value: 'Value 2'),
    DropDownValueModel(name: 'Item 3', value: 'Value 3'),
    DropDownValueModel(name: 'Item 4', value: 'Value 4'),
    DropDownValueModel(name: 'Item 5', value: 'Value 5'),
    DropDownValueModel(name: 'Item 6', value: 'Value 6'),
    DropDownValueModel(name: 'Item 7', value: 'Value 7'),
    DropDownValueModel(name: 'Item 8', value: 'Value 8'),
  ];

  final List<DropDownValueModel> exampleDropDownList2 = [
    DropDownValueModel(name: 'Item a', value: 'Value a'),
    DropDownValueModel(name: 'Item b', value: 'Value b'),
    DropDownValueModel(name: 'Item c', value: 'Value c'),
    DropDownValueModel(name: 'Item d', value: 'Value d'),
    DropDownValueModel(name: 'Item e', value: 'Value e'),
    DropDownValueModel(name: 'Item f', value: 'Value f'),
    DropDownValueModel(name: 'Item g', value: 'Value g'),
    DropDownValueModel(name: 'Item h', value: 'Value h'),
  ];
  static String searchColumnName = "Product";
  static String searchColumnName1 = "Stock";

  String extractItemName(String input) {
    RegExp regExp = RegExp(r'DropDownValueModel\((.*),.*\)');
    Match? match = regExp.firstMatch(input);
    
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    } 
    else {
      return "Wrong Structure";
    }
  }

  DropDownFormTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropDownForm(
                  hintText: 'DropDown 1', //optional attribute
                  width: 160.0, //optional attribute
                  height: 50.0, //optional attribute
                  dropDownList: exampleDropDownList, //optional attribute
                  onChange: (val) {
                    searchColumnName = extractItemName(val.toString());
                  },
                ),

                DropDownForm(
                  hintText: 'DropDown 2', //optional attribute
                  width: 160.0, //optional attribute
                  height: 50.0, //optional attribute
                  dropDownList: exampleDropDownList2, //optional attribute
                  onChange: (val) {
                    searchColumnName1 = extractItemName(val.toString());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//void main() {
//  runApp(MaterialApp(home: DropDownFormTest()));
//}