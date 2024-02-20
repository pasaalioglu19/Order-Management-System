import 'package:flutter/material.dart';
import 'package:oms/frontend/components/styled_button.dart';
import 'package:oms/frontend/components/table_window_components/table.dart';
import 'package:oms/frontend/trials/table_test/table_data.dart';

class TableWindow extends StatefulWidget {
  TableWindow({required this.tableApiName, this.isMultiSearch = false, super.key});

  bool isMultiSearch; // add a drawer to determine search column
  String tableApiName;

  @override
  State<TableWindow> createState() => _TableWindowState();
}

class _TableWindowState extends State<TableWindow> {
  
  final searchController = TextEditingController();
  late CustomTableWidget table;
  late String searchValue;
  late int pageIndex;
  late int totalPageNumber;

  
  @override
  void initState() {
    super.initState();
    
    pageIndex = 1;
    searchValue = "";
    // request total page number from api
    // request table from api

    // untill test api implemented
    if(widget.tableApiName == "test_product")
    {
      totalPageNumber = 3;
      table = CustomTableWidget.fromData(data: my_data);
    }

    if(widget.tableApiName == "test_stock")
    {
      totalPageNumber = 2;
      table = CustomTableWidget.fromData(data: my_data2);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 150,
              height: 35,
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            StyledButton(
              flex: 0,
              title: 'Search',
              onPressed: () {
                setState(() {
                  searchValue = searchController.text;
                  pageIndex = 1;
                  // // EXAMPLE SEARCH REQUEST
                  // // request arguments: page_index = 1, searchValue, tableApi
                  // setState(() {
                  //   table = CustomTableWidget.fromData(data: RESPOND,); 
                  // }); 
                });
              }, 
            ),
            StyledButton(
              flex: 0,
              title: 'Clear',
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                  searchValue = "";
                  searchController.text = "";
                  // request again
                });
              }, 
            ),
          ],
        ),
    
        table, // nested table
    
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pageIndex > 1)
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        setState(() {
                          pageIndex -= 1;
                          // // EXAMPLE PAGE REQUEST
                          // // request arguments: page_index = pageIndex - 1, tableApi, searchValue 
                          // setState(() {
                          //   table = CustomTableWidget.fromData(data: RESPOND,); 
                          // });
                        });
                      }, 
                    ),
                  ),
            if (pageIndex == 1)
              SizedBox(height: 40, width: 40,),
            Text(
              '${pageIndex}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (pageIndex < totalPageNumber)
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        setState(() {
                          pageIndex += 1;
                          // // EXAMPLE PAGE REQUEST
                          // // request arguments: page_index = pageIndex + 1, tableApi, searchValue 
                          // setState(() {
                          //   table = CustomTableWidget.fromData(data: RESPOND,); 
                          // });
                        });
                      }, 
                    ),
                  ),
            if (pageIndex == totalPageNumber)
              SizedBox(height: 40, width: 40,),
          ],
        ),
      ],
    );
  }
}