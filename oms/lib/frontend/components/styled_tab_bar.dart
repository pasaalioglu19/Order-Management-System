import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

class StyledTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List tab_texts;
  const StyledTabBar({super.key, tab, required this.tab_texts});

  @override
  State<StyledTabBar> createState() => _StyledTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); 
}

class _StyledTabBarState extends State<StyledTabBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ButtonsTabBar(
            center: false,
            backgroundColor: const Color(0xffADAC6F),
            unselectedBackgroundColor: const Color(0xffE2DFC3),
            buttonMargin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            contentPadding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
            radius: 20,              
            tabs: [for (var text in widget.tab_texts) Tab(text: text,)],
          )
        ],
      ),
    );
  }
}
