import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';

import 'package:oms/backend/models/Order.dart';
import 'package:oms/backend/api/OrderApi.dart';
import 'package:oms/Globals/States.dart';

class AnalysisPage extends StatefulWidget {
  final String warehouseID;

  const AnalysisPage({
    Key? key,
    required this.warehouseID,
  }) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late final Future<List<Orders>> preparingOrders;
  late final Future<List<Orders>> pendingOrders;
  late final Future<List<Orders>> awaitingConfirmationOrders;
  late final Future<List<Orders>> onDeliveryOrders;
  late final Future<List<Orders>> deliveredOrders;
  late final Future<List<Orders>> cancelledOrders;
  late final Future<List<Orders>> undeliverableOrders;

  @override
  void initState() {
    preparingOrders = OrderAPI.getOrdersByField(
        warehouse_id: widget.warehouseID, fieldName: 'state', fieldValue: OrderStates.Preparing);
    pendingOrders = OrderAPI.getOrdersByField(
        warehouse_id: widget.warehouseID, fieldName: 'state', fieldValue: OrderStates.Pending);
    awaitingConfirmationOrders = OrderAPI.getOrdersByField(
        warehouse_id: widget.warehouseID, fieldName: 'state', fieldValue: OrderStates.AwaitingConfirmation);
    onDeliveryOrders = OrderAPI.getOrdersByField(
        warehouse_id: widget.warehouseID, fieldName: 'state', fieldValue: OrderStates.OnDelivery);
    deliveredOrders = OrderAPI.getOrdersByField(
        warehouse_id: widget.warehouseID, fieldName: 'state', fieldValue: OrderStates.Delivered);
    cancelledOrders = OrderAPI.getOrdersByField(
        warehouse_id: widget.warehouseID, fieldName: 'state', fieldValue: OrderStates.Cancelled);
    undeliverableOrders = OrderAPI.getOrdersByField(
        warehouse_id: widget.warehouseID, fieldName: 'state', fieldValue: OrderStates.Undeliverable);

    super.initState();

    preparingOrders
        .then((orders) => print('Preparing Orders: ${orders.length}'));
    pendingOrders.then((orders) => print('Pending Orders: ${orders.length}'));
    awaitingConfirmationOrders.then(
        (orders) => print('Awaiting Confirmation Orders: ${orders.length}'));
    onDeliveryOrders
        .then((orders) => print('On Delivery Orders: ${orders.length}'));
    deliveredOrders
        .then((orders) => print('Delivered Orders: ${orders.length}'));
    cancelledOrders
        .then((orders) => print('Cancelled Orders: ${orders.length}'));
    undeliverableOrders
        .then((orders) => print('Undeliverable Orders: ${orders.length}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Divider(
                color: Color(0xFFE9E9E9),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                'Orders Pie Chart',
                style: TextStyle(
                  fontFamily: GoogleFonts.niramit().fontFamily,
                  fontSize: 24,
                  color: Color(0xff447057),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: 200,
              height: 200,
              child: FutureBuilder<Map<String, int>>(
                future: _getOrderCounts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No Orders Found'));
                  } else {
                    return OrderChart(
                      preparingCount: snapshot.data!['preparing'] ?? 0,
                      pendingCount: snapshot.data!['pending'] ?? 0,
                      awaitingConfirmationCount:
                          snapshot.data!['awaitingConfirmation'] ?? 0,
                      onDeliveryCount: snapshot.data!['onDelivery'] ?? 0,
                      deliveredCount: snapshot.data!['delivered'] ?? 0,
                      cancelledCount: snapshot.data!['cancelled'] ?? 0,
                      undeliverableCount: snapshot.data!['undeliverable'] ?? 0,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Divider(
                color: Color(0xFFE9E9E9),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                'Orders Bar Chart',
                style: TextStyle(
                  fontFamily: GoogleFonts.niramit().fontFamily,
                  fontSize: 24,
                  color: Color(0xff447057),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: MediaQuery.of(context).size.width,
              height: 200, // Çubuk grafiğin yüksekliği
              child: FutureBuilder<Map<String, int>>(
                future: _getOrderCounts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No Orders Found'));
                  } else {
                    return OrderBarChart(
                      preparingCount: snapshot.data!['preparing'] ?? 0,
                      pendingCount: snapshot.data!['pending'] ?? 0,
                      awaitingConfirmationCount:
                          snapshot.data!['awaitingConfirmation'] ?? 0,
                      onDeliveryCount: snapshot.data!['onDelivery'] ?? 0,
                      deliveredCount: snapshot.data!['delivered'] ?? 0,
                      cancelledCount: snapshot.data!['cancelled'] ?? 0,
                      undeliverableCount: snapshot.data!['undeliverable'] ?? 0,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, int>> _getOrderCounts() async {
    var preparing = await preparingOrders;
    var pending = await pendingOrders;
    var awaitingConfirmation = await awaitingConfirmationOrders;
    var onDelivery = await onDeliveryOrders;
    var delivered = await deliveredOrders;
    var cancelled = await cancelledOrders;
    var undeliverable = await undeliverableOrders;

    return {
      'preparing': preparing.length,
      'pending': pending.length,
      'awaitingConfirmation': awaitingConfirmation.length,
      'onDelivery': onDelivery.length,
      'delivered': delivered.length,
      'cancelled': cancelled.length,
      'undeliverable': undeliverable.length,
    };
  }
}

class OrderChart extends StatefulWidget {
  final int preparingCount;
  final int pendingCount;
  final int awaitingConfirmationCount;
  final int onDeliveryCount;
  final int deliveredCount;
  final int cancelledCount;
  final int undeliverableCount;

  OrderChart({
    required this.preparingCount,
    required this.pendingCount,
    required this.awaitingConfirmationCount,
    required this.onDeliveryCount,
    required this.deliveredCount,
    required this.cancelledCount,
    required this.undeliverableCount,
  });

  @override
  _OrderChartState createState() => _OrderChartState();
}

class _OrderChartState extends State<OrderChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (pieTouchResponse != null && event is! FlPanEndEvent) {
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              } else {
                touchedIndex = -1;
              }
            });
          },
        ),
        sections: _buildSections(),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      _buildSection(widget.preparingCount, 'Preparing', Colors.blue, 0),
      _buildSection(widget.pendingCount, 'Pending', Colors.red, 1),
      _buildSection(widget.awaitingConfirmationCount, 'Awaiting Confirmation',
          Colors.orange, 2),
      _buildSection(widget.onDeliveryCount, 'On Delivery', Colors.green, 3),
      _buildSection(widget.deliveredCount, 'Delivered', Colors.purple, 4),
      _buildSection(widget.cancelledCount, 'Cancelled', Colors.grey, 5),
      _buildSection(
          widget.undeliverableCount, 'Undeliverable', Colors.brown, 6),
    ];
  }

  PieChartSectionData _buildSection(
      int count, String title, Color color, int index) {
    final isTouched = index == touchedIndex;
    final fontSize = isTouched ? 18.0 : 16.0;
    final radius = isTouched ? 60.0 : 50.0;

    return PieChartSectionData(
      color: color,
      value: count.toDouble(),
      title: isTouched ? '$title\n$count' : '$title',
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
      ),
      radius: radius,
    );
  }
}

class OrderBarChart extends StatelessWidget {
  final int preparingCount;
  final int pendingCount;
  final int awaitingConfirmationCount;
  final int onDeliveryCount;
  final int deliveredCount;
  final int cancelledCount;
  final int undeliverableCount;

  OrderBarChart({
    required this.preparingCount,
    required this.pendingCount,
    required this.awaitingConfirmationCount,
    required this.onDeliveryCount,
    required this.deliveredCount,
    required this.cancelledCount,
    required this.undeliverableCount,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const titles = [
                  'Prep',
                  'Pend',
                  'Await',
                  'OnDel',
                  'Deliv',
                  'Canc',
                  'Undel'
                ];
                return RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    titles[value.toInt()],
                    style: const TextStyle(color: Colors.black, fontSize: 11),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 10));
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: _buildBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (index) {
      switch (index) {
        case 0:
          return makeGroupData(0, preparingCount.toDouble(),
              isTouched: index == preparingCount);
        case 1:
          return makeGroupData(1, pendingCount.toDouble(),
              isTouched: index == pendingCount);
        case 2:
          return makeGroupData(2, awaitingConfirmationCount.toDouble(),
              isTouched: index == awaitingConfirmationCount);
        case 3:
          return makeGroupData(3, onDeliveryCount.toDouble(),
              isTouched: index == onDeliveryCount);
        case 4:
          return makeGroupData(4, deliveredCount.toDouble(),
              isTouched: index == deliveredCount);
        case 5:
          return makeGroupData(5, cancelledCount.toDouble(),
              isTouched: index == cancelledCount);
        case 6:
          return makeGroupData(6, undeliverableCount.toDouble(),
              isTouched: index == undeliverableCount);
        default:
          return throw Error();
      }
    });
  }

  BarChartGroupData makeGroupData(int x, double y, {bool isTouched = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isTouched ? Colors.lightBlueAccent : Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          width: 22,
        ),
      ],
    );
  }
}
