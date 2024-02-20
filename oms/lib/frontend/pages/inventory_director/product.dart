import 'package:flutter/material.dart';
import 'package:oms/frontend/components/addattribute.dart';
import 'package:oms/frontend/components/divider.dart';
import 'package:oms/frontend/components/form_box.dart';
import 'package:oms/frontend/components/pop_up.dart';
import 'package:oms/frontend/components/styled_button.dart';

class ProductPage extends StatefulWidget {
  final String warehouseID;
  const ProductPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const DividerForm(),
        Row(
          children: [
            StyledButton(
              onPressed: _addNewProductDialog,
              title: 'Add New Product',
              flex: 1,
            ),
          ],
        ),
        const DividerForm(),
      ],
    );
  }

  // Add New Product Pop-Up
  void _addNewProductDialog() {
    final TextEditingController _productNameController =
        TextEditingController();
    List<TextEditingController> _propertyTypeControllers = [
      TextEditingController()
    ];
    List<List<TextEditingController>> _propertyNamesControllersList = [[]];

    int prTypFlag = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
              backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
              child: PopUp(
                  labelText: 'Add New Product',
                  bodyPart: SingleChildScrollView(
                    child: Column(children: [
                      FormBox(
                        controller: _productNameController,
                        labelText: 'Product Name',
                        alignment: Alignment
                            .centerRight, // The alignment value for box
                        constraints: const BoxConstraints(
                            maxWidth: 320.0,
                            maxHeight: 50.0), // Box size limits
                      ),
                      const SizedBox(height: 10.0),
                      AddAttribute(
                        padding:
                            const EdgeInsets.fromLTRB(35.0, 0.0, 20.0, 0.0),
                        onTap: () {
                          if (_productNameController.text.isNotEmpty) {
                            setState(() {
                              prTypFlag = 1;
                            });

                            return;
                          }
                        },
                        buttonText: 'Add New Property',
                      ),
                      const SizedBox(height: 10.0),
                      if (prTypFlag == 1)
                        Column(
                          children: [
                            for (var j = 0;
                                j < _propertyTypeControllers.length;
                                j++)
                              Column(
                                children: [
                                  FormBox(
                                    controller: _propertyTypeControllers[j],
                                    labelText: 'Property Type',
                                    alignment: Alignment
                                        .centerRight, // The alignment value for box
                                    constraints: const BoxConstraints(
                                        maxWidth: 290.0,
                                        maxHeight: 50.0), // Box size limits
                                  ),

                                  const SizedBox(height: 5.0),
                                  // Property Name boxes
                                  for (var i = 0;
                                      i <
                                          _propertyNamesControllersList[j]
                                              .length;
                                      i++)
                                    Column(
                                      children: [
                                        FormBox(
                                          controller:
                                              _propertyNamesControllersList[j]
                                                  [i],
                                          labelText: 'Property Name',
                                          alignment: Alignment
                                              .centerRight, // The alignment value for box
                                          constraints: const BoxConstraints(
                                              maxWidth: 250.0,
                                              maxHeight:
                                                  50.0), // Box size limits
                                        ),
                                        const SizedBox(height: 5.0),
                                      ],
                                    ),

                                  const SizedBox(height: 5.0),

                                  AddAttribute(
                                    padding: const EdgeInsets.fromLTRB(
                                        100.0, 0.0, 20.0, 0.0),
                                    onTap: () {
                                      if (_propertyNamesControllersList[j]
                                          .isEmpty) {
                                        if (_propertyTypeControllers[j]
                                            .text
                                            .isNotEmpty) {
                                          setState(() {
                                            _propertyNamesControllersList[j]
                                                .add(TextEditingController());
                                          });
                                        }
                                      } else {
                                        if (_propertyNamesControllersList[j][
                                                _propertyNamesControllersList[j]
                                                        .length -
                                                    1]
                                            .text
                                            .isNotEmpty) {
                                          setState(() {
                                            _propertyNamesControllersList[j]
                                                .add(TextEditingController());
                                          });
                                        }
                                      }
                                    },
                                    buttonText: 'Add Property Name',
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10.0),
                            AddAttribute(
                              padding: const EdgeInsets.fromLTRB(
                                  65.0, 0.0, 20.0, 0.0),
                              onTap: () {
                                if (_propertyTypeControllers[
                                        _propertyTypeControllers.length - 1]
                                    .text
                                    .isNotEmpty) {
                                  setState(() {
                                    _propertyTypeControllers
                                        .add(TextEditingController());
                                    _propertyNamesControllersList.add([]);
                                  });
                                }
                              },
                              buttonText: 'Add New Property',
                            ),
                          ],
                        ),
                    ]),
                  ),
                  buttonPart: [
                    StyledButton(
                      title: 'Save',
                      onPressed: () {
                        if (_productNameController.text.isNotEmpty) {
                          print(_productNameController.text); //Product name
                          for (var k = 0;
                              k < _propertyTypeControllers.length;
                              k++) {
                            print(_propertyTypeControllers[k]
                                .text); // PropertyType
                            for (var l = 0;
                                l < _propertyNamesControllersList[k].length;
                                l++) {
                              print(_propertyNamesControllersList[k][l]
                                  .text); // PropertyName
                            }
                          }
                        }
                      },
                    ),
                  ]),
            );
          },
        );
      },
    );
  }
}
