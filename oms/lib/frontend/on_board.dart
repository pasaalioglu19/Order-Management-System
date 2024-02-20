import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:oms/frontend/page_auth.dart';
import 'package:oms/frontend/pages/any_actor/home_page.dart';
import 'package:oms/frontend/login/login_page.dart';
import 'package:oms/backend/models/Staff.dart';
import 'package:oms/backend/api/StaffApi.dart';

class OnBoardWidget extends StatefulWidget {
  const OnBoardWidget({Key? key}) : super(key: key);

  @override
  State<OnBoardWidget> createState() => _OnBoardWidgetState();
}

class _OnBoardWidgetState extends State<OnBoardWidget> {
  PageAuth? pageAuth;
  bool? _isLogged;
  String _userId = "";
  String _warehouseId = "";

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        setState(() {
          _isLogged = false;
        });
      } else {
        Staff staff = await StaffAPI.getOne(user.uid);

        setState(() {
          _userId = user.uid;
          _warehouseId = staff.warehouse_id;
        });

        if (staff.last_seen_time.toDate().difference(DateTime.now()).inHours <=
            -1) {
          setState(() {
            _isLogged = false;
          });
          await FirebaseAuth.instance.signOut();
        } else {
          setState(() {
            _isLogged = true;
            pageAuth = PageAuth(staff.job, _warehouseId);
          });
          StaffAPI.updateOne(
              user.uid, {"last_seen_time": Timestamp.fromDate(DateTime.now())});
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLogged == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _isLogged!
            ? pageAuth == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : HomePage(
                    pageAuth: pageAuth!,
                    staffID: _userId,
                    warehouseID: _warehouseId,
                  )
            : const EmailSignInPage();
  }
}
