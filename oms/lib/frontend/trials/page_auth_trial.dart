import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:oms/frontend/page_auth.dart';
import 'package:oms/frontend/components/styled_tab_bar.dart';

class PageAuthTest extends StatelessWidget {
  final PageAuth pageAuth = PageAuth("call center");
  
  @override
  Widget build(BuildContext context) {
    final List<String> pageNames = pageAuth.getAuthorizedPagesNames();
    final List<Widget> pages = pageAuth.getAuthorizedPages();
    final int lenght = pageNames.length;
  
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.niramitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: DefaultTabController(
        length: lenght,
        child: Scaffold(
          appBar: AppBar(
            bottom: StyledTabBar(tab_texts: pageNames,),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ), 
    );
  }
}

//çalıştırmak için aşağıdaki kodu kopyalayabilirsiniz
// void main() => runApp(PageAuthTest());