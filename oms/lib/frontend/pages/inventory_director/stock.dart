import 'package:flutter/material.dart';
import 'package:oms/backend/api/StockApi.dart';
import 'package:oms/backend/models/Stock.dart';
import 'package:oms/frontend/components/divider.dart';
import 'package:oms/frontend/components/dropdown_form.dart';
import 'package:oms/frontend/components/form_box.dart';
import 'package:oms/frontend/components/pop_up.dart';
import 'package:oms/frontend/components/styled_button.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:oms/frontend/components/text_box.dart';



class StockPage extends StatefulWidget {
  final String warehouseID;

  const StockPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const DividerForm(),

        Row(
          children: [
            const SizedBox(width: 20.0),
            StyledButton(
              onPressed: _addStockDialog,
              title: 'Add Stock',
              flex: 1,
            ),
            const SizedBox(width: 20.0),
            StyledButton(
              onPressed: _updateStockDialog,
              title: 'Update Stock',
              flex: 1,
            ),
            const SizedBox(width: 20.0),
          ],
        ),

        const DividerForm(),

      ],
    );
  }

  // Add Stock Pop-Up
  void _addStockDialog() async{
    final TextEditingController amountController = TextEditingController();
    final List<DropDownValueModel> dropDownProductName = [];
    final List<DropDownValueModel> dropDownPropertyName = [];


    List<String> k2 = ["Feature 1","Feature 2","Feature 3"];

    String searchProductName = "Product";

    String productName = 'Product Name';
    int productIndex = 0;
    String propertyType = "Property Type";
    String propertyName = "Property Name";


    List<Stock> allProducts = await StockAPI.getAll();
    if (!context.mounted) return;
    
    //get Product Name
    for(var p = 0; p < allProducts.length; p++){
      dropDownProductName.add(DropDownValueModel(name: allProducts[p].stock_name, value: 'Value $p'));
    }

    //get Property Type
    void propertyTypeGetter(String productName){
      for(var p = 0; p < allProducts.length; p++){
        if(allProducts[p].stock_name == productName){
          productIndex = p;
          break;
        }
      }

      propertyType = allProducts[productIndex].category.category_name;

      List<dynamic>? allAttributes = allProducts[productIndex].category.attributes[propertyType];
      print(allAttributes);

/*       dropDownPropertyName.add(DropDownValueModel(name: allAttributes?[0], value: 'Value $productIndex')); */
    }


    List<String> propertyNameList = k2;//(get product list);
    for(var p = 0; p < propertyNameList.length; p++){
      dropDownPropertyName.add(DropDownValueModel(name: propertyNameList[p], value: 'Value $p'));
    }

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

    int attributeFlag = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( 
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
              backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
              child: PopUp(
                labelText: 'Add Stock',
                bodyPart: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [             
                      DropDownForm(
                        hintText: productName, //optional attribute
                        width: 320.0, //optional attribute
                        height: 45.0, //optional attribute
                        dropDownList: dropDownProductName, //optional attribute
                        onChange: (val) {
                          setState(() {
                            searchProductName = extractItemName(val.toString());
                            propertyTypeGetter(searchProductName);
                            attributeFlag = 1;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      
                      if(attributeFlag == 1)
                        Column(
                          children: [
                            const Row(
                              children: [
                                SizedBox(width: 70.0),
                                Text(
                                  "Attributes:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                // Diğer widget'ları da buraya ekleyebilirsiniz.
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 60.0),
                                DropDownForm(
                                  hintText: propertyType, //optional attribute
                                  width: 290.0, //optional attribute
                                  height: 45.0, //optional attribute
                                  dropDownList: dropDownPropertyName, //optional attribute
                                  onChange: (val) {
                                    setState(() {
                                      propertyName = extractItemName(val.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 10.0),

                      FormBox(
                        controller: amountController, 
                        labelText: "Amount",
                        constraints: const BoxConstraints(maxWidth: 350.0, maxHeight: 45.0),
                      ), 
                    ]
                  )
                ),

                

                buttonPart: [
                  StyledButton(
                    title: 'Add',
                    onPressed: () {
                      if(amountController.text.isEmpty){
                        print("Please enter amount");
                      }
                      else if(searchProductName == ""){
                        print("Please select product");
                      }
                      else if(propertyType == ""){
                        print("Please select property type");
                      }
                      else if(propertyName == ""){
                        print("Please select property name");
                      }
                      else{
                        print(searchProductName);
                        print(propertyType);
                        print(propertyName);
                      }
                    },
                  ),
                ]
              ),
            );
          },
        );
      }
    );
  }

  void _updateStockDialog() async{
    final TextEditingController amountController = TextEditingController();
    final List<DropDownValueModel> dropDownProductName = [];
    final List<DropDownValueModel> dropDownPropertyName = [];
    int amountFlag = 0;


    List<String> k2 = ["Feature 1","Feature 2","Feature 3"];

    String searchProductName = "Product";

    String productName = 'Product Name';
    int productIndex = 0;
    String propertyType = "Property Type";
    String propertyName = "Property Name";


    List<Stock> allProducts = await StockAPI.getAll();
    if (!context.mounted) return;
    
    //get Product Name
    for(var p = 0; p < allProducts.length; p++){
      dropDownProductName.add(DropDownValueModel(name: allProducts[p].stock_name, value: 'Value $p'));
    }

    //get Property Type
    void propertyTypeGetter(String productName){
      for(var p = 0; p < allProducts.length; p++){
        if(allProducts[p].stock_name == productName){
          productIndex = p;
          break;
        }
      }

      propertyType = allProducts[productIndex].category.category_name;

      List<dynamic>? allAttributes = allProducts[productIndex].category.attributes[propertyType];
      print(allAttributes);

/*       dropDownPropertyName.add(DropDownValueModel(name: allAttributes?[0], value: 'Value $productIndex')); */
    }


    List<String> propertyNameList = k2;//(get product list);
    for(var p = 0; p < propertyNameList.length; p++){
      dropDownPropertyName.add(DropDownValueModel(name: propertyNameList[p], value: 'Value $p'));
    }

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

    int attributeFlag = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( 
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
              backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
              child: PopUp(
                labelText: 'Update Stock',
                bodyPart: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [             
                      DropDownForm(
                        hintText: productName, //optional attribute
                        width: 320.0, //optional attribute
                        height: 45.0, //optional attribute
                        dropDownList: dropDownProductName, //optional attribute
                        onChange: (val) {
                          setState(() {
                            searchProductName = extractItemName(val.toString());
                            propertyTypeGetter(searchProductName);
                            attributeFlag = 1;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      
                      if(attributeFlag == 1)
                        Column(
                          children: [
                            const Row(
                              children: [
                                SizedBox(width: 70.0),
                                Text(
                                  "Attributes:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                // Diğer widget'ları da buraya ekleyebilirsiniz.
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 60.0),
                                DropDownForm(
                                  hintText: propertyType, //optional attribute
                                  width: 290.0, //optional attribute
                                  height: 45.0, //optional attribute
                                  dropDownList: dropDownPropertyName, //optional attribute
                                  onChange: (val) {
                                    setState(() {
                                      propertyName = extractItemName(val.toString());
                                      amountFlag = 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 10.0),

                      if(amountFlag == 1)
                        const TextBox(
                          alignment: Alignment.bottomRight,
                          constraints: BoxConstraints(maxWidth: 290.0, maxHeight: 45.0),
                          margin: EdgeInsets.symmetric(horizontal: 30.0),
                          labelText: "Amount : 5",
                        ),

                      const SizedBox(height: 10.0),

                      FormBox(
                        controller: amountController, 
                        labelText: "New Amount",
                        constraints: const BoxConstraints(maxWidth: 350.0, maxHeight: 45.0),
                      ), 
                    ]
                  )
                ),

                

                buttonPart: [
                  StyledButton(
                    title: 'Update',
                    onPressed: () {
                      if(amountController.text.isEmpty){
                        print("Please enter amount");
                      }
                      else if(searchProductName == ""){
                        print("Please select product");
                      }
                      else if(propertyType == ""){
                        print("Please select property type");
                      }
                      else if(propertyName == ""){
                        print("Please select property name");
                      }
                      else{
                        print(searchProductName);
                        print(propertyType);
                        print(propertyName);
                      }
                    },
                  ),
                ]
              ),
            );
          },
        );
      }
    );
  }
}