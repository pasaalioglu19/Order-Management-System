/*
  new dependency is neeeded: expandable: ^5.0.1
  to download it, write cmd: flutter pub add expandable, flutter pub get

  https://pub.dev/packages/expandable

  structure of one row:
  ExpandableNotifier(      // <-- This is where your controller lives
     //...
     ScrollOnExpand(        // <-- Wraps the widget to scroll
      //...
        ExpandablePanel(    // <-- Your Expandable or ExpandablePanel
          //...
        )
     )
  )

*/

import 'dart:math' as math;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:oms/frontend/model/table_tree.dart';

class CustomTableWidget extends StatefulWidget {
  CustomTableWidget({super.key}) : data = Tree();
  CustomTableWidget.fromData({super.key, required this.data});
  Tree data;

  @override
  State createState() {
    return CustomTableState();
  }
}

class CustomTableState extends State<CustomTableWidget> {
  final double paddingMultplier = 10.0;
  final double iconSize = 28.0;
  final double containerHeight = 50.0;
  final Color rowBackGroundColor =
      Colors.white; //const Color.fromARGB(255, 247, 244, 201);
  final Color headerBackGroundColor = Colors.grey;
  final Color divColor = Colors.black;
  final List<ExpandableController> expControllers = [];

  @override
  void dispose() {
    for (var i = 0; i < expControllers.length; i++) {
      expControllers.last.dispose();
      expControllers.removeLast();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTable(widget.data.head, 0);
  }

  Widget _buildTable(HeaderNode headn, int level) {
    double paddingVal = paddingMultplier * level;

    return ExpandableTheme(
      data: const ExpandableThemeData(
        iconColor: Colors.blue,
        useInkWell: true,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: paddingVal),
        child: Column(
          children: <Widget>[
            // one header

            _buildAttributes(headn.attributes,
                label: "head",
                leftSpace: paddingVal,
                iconSize: iconSize,
                height: containerHeight,
                id: -1), // headers don't have any button

            // multiple rows
            ..._buildTableRows(headn, level),
          ],
        ),
      ),
    );
  }

  List<ExpandableNotifier> _buildTableRows(HeaderNode headn, int level) {
    double paddingVal = paddingMultplier * level;

    return headn.children.map<ExpandableNotifier>((RowNode rown) {
      expControllers.add(ExpandableController());

      return ExpandableNotifier(
        controller: expControllers.last,
        child: ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: false,
                  tapBodyToCollapse: false,
                  tapHeaderToExpand: true,
                  hasIcon: false,
                ),
                header: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          if (rown.children
                              .isNotEmpty) // if row has children add it's icon
                            ExpandableIcon(
                              theme: ExpandableThemeData(
                                expandIcon: Icons.arrow_drop_up_outlined,
                                collapseIcon: Icons.arrow_drop_down,
                                iconColor: Colors.grey,
                                iconSize: iconSize,
                                iconRotationAngle: math.pi / 2,
                                iconPadding: const EdgeInsets.only(right: 1),
                                hasIcon: false,
                              ),
                            ),
                          Expanded(
                            child:
                              // inline if condition, if we are not considering first level there cannot be any buttons
                              (level == 0) ?  
                                _buildAttributes(rown.attributes,
                                leftSpace: paddingVal,
                                iconSize:
                                    rown.children.isEmpty ? iconSize : 0.0,
                                height: containerHeight,
                                id: rown.id,
                                updButton: rown.update_button,
                                delButton: rown.del_button,
                                showButton: rown.show_button) 
                                :
                                _buildAttributes(rown.attributes,
                                leftSpace: paddingVal,
                                iconSize:
                                    rown.children.isEmpty ? iconSize : 0.0,
                                height: containerHeight,
                                id: -1)
                                
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                collapsed: const SizedBox.shrink(),
                expanded: Column(
                  children: [
                    // expand multpile tables from their headers
                    ...rown.children.map<Widget>((HeaderNode header2n) =>
                        _buildTable(header2n, level + 1))
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAttributes(List<String> rowContent,
      {double leftSpace = 0.0,
      String label = "row",
      double iconSize = 0.0,
      double height = 20.0,
      int id = -1, // headers don't posses any button, 
                   //so they don't need an id value for specific opearations
      bool updButton = false,
      bool delButton = false,
      bool showButton = false,}) {
    Color myColor = rowBackGroundColor;
    Widget Lspace =
        SizedBox(width: leftSpace + iconSize); // padding + icon size
    if (label == "head") {
      // if it is a header row
      height += 5;
      myColor = headerBackGroundColor;
    }
    return Container(
      height: height,
      color: myColor,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Lspace,
                ...rowContent.map(
                  (attribute) => Expanded(
                    child: Text(
                      attribute,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (updButton)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {}, // request a pop-up window content based on the id variable
                  ),
                if (delButton)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {}, // request a pop-up window content based on the id variable
                  ),
                if (showButton)
                  IconButton(
                    icon: const Icon(Icons.person_search_rounded),
                    onPressed: () {}, // request a pop-up window content based on the id variable
                  ),
              ],
            ),
          ),
          if (label != "head") // if not header row add a border line / div below
            Expanded(
              child: Divider(
                thickness: 0.5,
                color: divColor,
              ),
            )
        ],
      ),
    );
  }
}
