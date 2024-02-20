import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:oms/frontend/components/drawer.dart';
import 'package:oms/frontend/components/styled_tab_bar.dart';
import 'package:oms/frontend/page_auth.dart';
import 'package:oms/frontend/pages/any_actor/profile.dart';

class HomePage extends StatefulWidget {
  final PageAuth pageAuth;
  final String staffID;
  final String warehouseID;

  const HomePage(
      {Key? key,
      required this.pageAuth,
      required this.staffID,
      required this.warehouseID})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<String> pageNames = widget.pageAuth.getAuthorizedPagesNames();
  late final List<Widget> pages = widget.pageAuth.getAuthorizedPages();
  late final int length = pageNames.length;

  bool isProfilePage = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.niramitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: DefaultTabController(
        length: length,
        child: Scaffold(
          appBar: AppBar(
            bottom: isProfilePage
                ? null
                : StyledTabBar(
                    tab_texts: pageNames,
                  ),
          ),
          drawer: CustomDrawer(
            currentPage: isProfilePage ? 'Profile' : 'Home',
            homeOnTap: () {
              setState(() {
                isProfilePage = false;
              });
            },
            profileOnTap: () {
              setState(() {
                isProfilePage = true;
              });
            },
          ),
          body: isProfilePage
              ? Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Profile(
                      staffID: widget.staffID,
                    ),
                  ),
                )
              : TabBarView(
                  children: pages,
                ),
        ),
      ),
    );
  }
}
