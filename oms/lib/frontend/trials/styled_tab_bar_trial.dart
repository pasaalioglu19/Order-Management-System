import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:oms/frontend/components/styled_tab_bar.dart';

class StyledTabBarTest extends StatelessWidget {
  final List tab_heads = ['Product', 'Stock', 'Tab1', 'Tab2', 'Tab3'];
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.niramitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: DefaultTabController(
        length: this.tab_heads.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: StyledTabBar(tab_texts: this.tab_heads,),
          ),
          body: const TabBarView(
            children: [
              Text('Product'),
              Text('Stock'),
              Text('Tab1'),
              Text('Tab2'),
              Text('Tab3'),
            ],
          ),
        ),
      ), 
    );
  }
}

//çalıştırmak için aşağıdaki kodu kopyalayabilirsiniz
// void main() => runApp(StyledTabBarTest());