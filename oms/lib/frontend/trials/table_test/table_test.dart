import 'package:flutter/material.dart';
import 'package:oms/frontend/components/table_window.dart';
import 'package:oms/frontend/trials/table_test/table_data.dart';

class ProductTableTest extends StatelessWidget {
  const ProductTableTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: TableWindow(
            tableApiName: "test_product",
          )
        ),
      ),
    );
  }
}

class StockTableTest extends StatelessWidget {
  const StockTableTest({super.key});

  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: TableWindow(
            tableApiName: "test_stock",
          ),
        ),
      ),
    );
  }
}


//çalıştırmak için aşağıdaki kodu kopyalayabilirsiniz
// void main() => runApp(ProductTableTest());
// void main() => runApp(StockTableTest());