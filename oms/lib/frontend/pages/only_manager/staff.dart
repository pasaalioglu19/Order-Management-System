import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:oms/backend/api/StaffApi.dart';
import 'dart:convert';

import 'package:oms/frontend/components/form_box.dart';
import 'package:oms/frontend/components/pop_up.dart';
import 'package:oms/frontend/components/styled_button.dart';
import 'package:oms/frontend/components/dropdown_form.dart';

import 'package:oms/backend/api/StaffApi.dart';

import 'package:oms/Globals/States.dart';

class StaffPage extends StatefulWidget {
  final String warehouseID;

  const StaffPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final List<DropDownValueModel> jobDropDownList = [
    DropDownValueModel(name: 'Call Center', value: 'Call Center'),
    DropDownValueModel(name: 'Inventory Director', value: 'Inventory Director'),
    DropDownValueModel(name: 'Deliverer', value: 'Deliverer'),
    DropDownValueModel(name: 'Manager', value: 'Manager'),
  ];
  String? selectedJob;

  String generateRandomPassword(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  Future<bool> sendMail(
      String recipientEmail, String subject, String content) async {
    var url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    var apiKey =
        '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'; // SendGrid API anahtarınızı buraya girin

    var emailData = {
      "personalizations": [
        {
          "to": [
            {"email": recipientEmail}
          ],
          "subject": subject
        }
      ],
      "content": [
        {"type": "text/plain", "value": content}
      ],
      "from": {"email": "bingol19@itu.edu.tr", "name": "Ahyet Bingöl"},
      "reply_to": {"email": "bingol19@itu.edu.tr", "name": "Ahyet Bingöl"}
    };

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(emailData),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      print('Email sent successfully');
      return true;
    } else {
      print('Failed to send email: ${response.body}');
      return false;
    }
  }

  Future<bool> sendFormDetails(BuildContext context) async {
    String password = generateRandomPassword(8);
    String content =
        "Your one-time password is given below:\n$password\nOnce you log in, it is recommended that you change your password.";

    bool success =
        await sendMail(emailController.text, "One-Time Password", content);

    if (success) {
      StaffAPI.insertWithMap({
        "name": nameController.text,
        "surname": surnameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
        "password": password,
        "state": PersonStates.WorkDay,
        "job": selectedJob,
        "warehouse_id": widget.warehouseID,
        "last_seen_time": Timestamp.fromDate(DateTime.now()),
      });
      return true;
    } else {
      return false;
    }
  }

  void clearForm() {
    nameController.clear();
    surnameController.clear();
    emailController.clear();
    phoneController.clear();
    setState(() {
      selectedJob = null;
    });
  }

  String extractItemName(String input) {
    RegExp regExp = RegExp(r'DropDownValueModel\((.*),.*\)');
    Match? match = regExp.firstMatch(input);

    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    } else {
      return "Wrong Structure";
    }
  }

  void _showAddStaffPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const PopUpTitle(labelText: 'Add Staff'),
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
                      controller: emailController,
                      labelText: 'Email',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                  SizedBox(height: 10),
                  FormBox(
                      controller: phoneController,
                      labelText: 'Phone',
                      constraints: BoxConstraints(maxWidth: 300, maxHeight: 50),
                      margin: EdgeInsets.symmetric(horizontal: 0)),
                  SizedBox(height: 10),
                  DropDownForm(
                    hintText: 'Select a job', //optional attribute
                    width: 300.0, //optional attribute
                    height: 50.0, //optional attribute
                    dropDownList: jobDropDownList, //optional attribute
                    onChange: (val) {
                      selectedJob = extractItemName(val.toString());
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            StyledButton(
              title: 'Save',
              onPressed: () async {
                String warning_message = "";
                if (nameController.text.isEmpty)
                  warning_message += "fill in the name field\n";
                if (surnameController.text.isEmpty)
                  warning_message += "fill in the surname field\n";
                if (emailController.text.isEmpty)
                  warning_message += "fill in the email field\n";
                if (phoneController.text.isEmpty)
                  warning_message += "fill in the phone field\n";

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
                  if (await sendFormDetails(context)) {
                    clearForm();
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content: const Text(
                              "Girdiğiniz mail adresi geçerli değil!"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
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
                title: 'Add Staff',
                onPressed: _showAddStaffPopup,
                flex: 1,
              ),
            ]),
            Divider(
              color: Color(0xFFE9E9E9),
              thickness: 1,
            ),
            Expanded(
              child: Center(
                child: Text('STAFF PAGE'), // TODO add table
              ),
            ),
          ],
        ),
      ),
    );
  }
}
