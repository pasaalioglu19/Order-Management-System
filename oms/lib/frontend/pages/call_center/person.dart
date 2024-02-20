import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // TODO remove

import 'package:oms/frontend/components/styled_button.dart';
import 'package:oms/frontend/components/pop_up.dart';
import 'package:oms/frontend/components/form_box.dart';

import 'package:oms/Globals/city_info.dart';

import 'package:oms/backend/api/CustomerApi.dart';

class PersonPage extends StatefulWidget {
  final String warehouseID;
  const PersonPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mapLocationController = TextEditingController();
  String? selectedCity;
  String? selectedDistrict;
  String? selectedNeighbourhood;
  List? infoAboutCity;

  @override
  void initState() {
    infoAboutCity = [selectedCity, selectedDistrict, selectedNeighbourhood];
    super.initState();
  }

  void clearForm() {
    nameController.clear();
    surnameController.clear();
    idController.clear();
    phoneController.clear();
    addressController.clear();
    mapLocationController.clear();
    setState(() {
      selectedCity = null;
      selectedDistrict = null;
      selectedNeighbourhood = null;
    });
  }

  void sendFormDetails() {
    CustomerAPI.insertWithMap(<String, dynamic>{
      'id': idController.text,
      'name': nameController.text,
      'surname': surnameController.text,
      'phone': phoneController.text,
      'city': infoAboutCity?[0],
      'district': infoAboutCity?[1],
      'neighbourhood': infoAboutCity?[2],
      'adress': addressController.text,
      'map_location': mapLocationController.text,
      'last_order_date': Timestamp.fromDate(DateTime.now()), // TODO remove
    });
  }

  void _showAddPersonPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const PopUpTitle(labelText: 'Add Person'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  FormBox(
                      controller: nameController,
                      labelText: 'Name',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                  SizedBox(height: 10),
                  FormBox(
                      controller: surnameController,
                      labelText: 'Surname',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                  SizedBox(height: 10),
                  FormBox(
                      controller: idController,
                      labelText: 'ID',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                  SizedBox(height: 10),
                  FormBox(
                      controller: phoneController,
                      labelText: 'Phone',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                  SizedBox(height: 10),
                  DropdownMulti(
                    onCityChanged: (value) {
                      infoAboutCity?[0] = value;
                    },
                    onDistrictChanged: (value) {
                      infoAboutCity?[1] = value;
                    },
                    onNeighbourhoodChanged: (value) {
                      infoAboutCity?[2] = value;
                    },
                  ),
                  SizedBox(height: 10),
                  FormBox(
                      controller: addressController,
                      labelText: 'Address',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                  SizedBox(height: 10),
                  FormBox(
                      controller: mapLocationController,
                      labelText: 'Map Location',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            StyledButton(
              title: 'Save',
              onPressed: () {
                String warning_message = "";
                if (nameController.text.isEmpty)
                  warning_message += "fill in the name field\n";
                if (surnameController.text.isEmpty)
                  warning_message += "fill in the surname field\n";
                if (idController.text.isEmpty)
                  warning_message += "fill in the ID field\n";
                if (phoneController.text.isEmpty)
                  warning_message += "fill in the phone field\n";
                if (infoAboutCity?[0] == null)
                  warning_message += "a city must be chosen\n";
                else if (infoAboutCity?[1] == null)
                  warning_message += "a district must be chosen\n";
                else if (infoAboutCity?[2] == null)
                  warning_message += "a neighborhood must be chosen\n";
                if (addressController.text.isEmpty)
                  warning_message += "fill in the address field\n";
                if (mapLocationController.text.isEmpty)
                  warning_message += "fill in the map location field\n";

                if (warning_message != "") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Warning'),
                        content: Text(warning_message),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  sendFormDetails();
                  clearForm();
                  Navigator.of(context).pop();
                }
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
                title: 'Add Person',
                onPressed: _showAddPersonPopup,
                flex: 1,
              ),
            ]),
            Divider(
              color: Color(0xFFE9E9E9),
              thickness: 1,
            ),
            Expanded(
              child: Center(
                child: Text('PERSON PAGE'), // TODO add table
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownMulti extends StatefulWidget {
  final Function(String?) onCityChanged;
  final Function(String?) onDistrictChanged;
  final Function(String?) onNeighbourhoodChanged;

  const DropdownMulti({
    Key? key,
    required this.onCityChanged,
    required this.onDistrictChanged,
    required this.onNeighbourhoodChanged,
  }) : super(key: key);

  @override
  _DropdownMultiState createState() => _DropdownMultiState();
}

class _DropdownMultiState extends State<DropdownMulti> {
  String? selectedIl;
  String? selectedIlce;
  String? selectedMahalle;

  Map<String, Map<String, List<String>>> data = cityInfo;

  void updateSelectedCity(String? newValue) {
    if (newValue != selectedIl) {
      widget.onCityChanged(newValue);
      selectedIl = newValue;
      selectedIlce = null;
      selectedMahalle = null;
    }
  }

  void updateSelectedDistrict(String? newValue) {
    if (newValue != selectedIlce) {
      widget.onDistrictChanged(newValue);
      selectedIlce = newValue;
      selectedMahalle = null;
    }
  }

  void updateSelectedNeighbourhood(String? newValue) {
    if (newValue != selectedMahalle) {
      widget.onNeighbourhoodChanged(newValue);
      selectedMahalle = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          buildDropdownButton(
            'Select City',
            selectedIl,
            data.keys.toList(),
            (newValue) => setState(() => updateSelectedCity(newValue)),
          ),
          if (selectedIl != null) SizedBox(height: 10),
          if (selectedIl != null)
            buildDropdownButton(
              'Select District',
              selectedIlce,
              data[selectedIl]!.keys.toList(),
              (newValue) => setState(() => updateSelectedDistrict(newValue)),
            ),
          if (selectedIlce != null) SizedBox(height: 10),
          if (selectedIlce != null)
            buildDropdownButton(
              'Select Neighboorhood',
              selectedMahalle,
              data[selectedIl]![selectedIlce]!,
              (newValue) =>
                  setState(() => updateSelectedNeighbourhood(newValue)),
            ),
        ],
      ),
    );
  }

  Widget buildDropdownButton(String hint, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Container(
      width: 300,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color.fromRGBO(209, 209, 209, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: TextStyle(
                color: Color(0xFF0A6C0E),
              )),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isExpanded: true,
        ),
      ),
    );
  }
}
