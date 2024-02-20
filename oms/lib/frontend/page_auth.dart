import 'package:flutter/material.dart';

import 'package:oms/frontend/pages/only_manager/analysis.dart';
import 'package:oms/frontend/pages/call_center/car.dart';
import 'package:oms/frontend/pages/deliverer/delivery.dart';
import 'package:oms/frontend/pages/call_center/order.dart';
import 'package:oms/frontend/pages/call_center/person.dart';
import 'package:oms/frontend/pages/inventory_director/product.dart';
import 'package:oms/frontend/pages/only_manager/staff.dart';
import 'package:oms/frontend/pages/inventory_director/stock.dart';
import 'package:oms/frontend/pages/deliverer/supply_status.dart';

class PageAuth {
  AnalysisPage? analysisPage;
  CarPage? carPage;
  DeliveryPage? deliveryPage;
  OrderPage? orderPage;
  PersonPage? personPage;
  ProductPage? productPage;
  StaffPage? staffPage;
  StockPage? stockPage;
  SupplyStatusPage? supplyStatusPage;

  PageAuth(String job, String warehouseID) {
    if (job.toLowerCase() == "manager") {
      this._initializeForManager(warehouseID);
    } else if (job.toLowerCase() == "call center") {
      this._initializeForCallCenter(warehouseID);
    } else if (job.toLowerCase() == "inventory director") {
      this._initializeForInventoryDirector(warehouseID);
    } else if (job.toLowerCase() == "deliverer") {
      this._initializeForDeliverer(warehouseID);
    } else {
      this._initializeForOthers(warehouseID);
    }
  }

  void _initializeForManager(String warehouseID) {
    this.analysisPage = AnalysisPage(warehouseID: warehouseID);
    this.carPage = CarPage(warehouseID: warehouseID);
    this.deliveryPage = DeliveryPage(warehouseID: warehouseID);
    this.orderPage = OrderPage(warehouseID: warehouseID);
    this.personPage = PersonPage(warehouseID: warehouseID);
    this.productPage = ProductPage(warehouseID: warehouseID);
    this.staffPage = StaffPage(warehouseID: warehouseID);
    this.stockPage = StockPage(warehouseID: warehouseID);
    this.supplyStatusPage = SupplyStatusPage(warehouseID: warehouseID);
  }

  void _initializeForCallCenter(String warehouseID) {
    this.analysisPage = null;
    this.carPage = CarPage(warehouseID: warehouseID);
    this.deliveryPage = null;
    this.orderPage = OrderPage(warehouseID: warehouseID);
    this.personPage = PersonPage(warehouseID: warehouseID);
    this.productPage = null;
    this.staffPage = null;
    this.stockPage = null;
    this.supplyStatusPage = null;
  }

  void _initializeForDeliverer(String warehouseID) {
    this.analysisPage = null;
    this.carPage = null;
    this.deliveryPage = DeliveryPage(warehouseID: warehouseID);
    this.orderPage = null;
    this.personPage = null;
    this.productPage = null;
    this.staffPage = null;
    this.stockPage = null;
    this.supplyStatusPage = SupplyStatusPage(warehouseID: warehouseID);
  }

  void _initializeForInventoryDirector(String warehouseID) {
    this.analysisPage = null;
    this.carPage = null;
    this.deliveryPage = null;
    this.orderPage = null;
    this.personPage = null;
    this.productPage = ProductPage(warehouseID: warehouseID);
    this.staffPage = null;
    this.stockPage = StockPage(warehouseID: warehouseID);
    this.supplyStatusPage = null;
  }

  void _initializeForOthers(String warehouseID) {
    this.analysisPage = null;
    this.carPage = null;
    this.deliveryPage = null;
    this.orderPage = null;
    this.personPage = null;
    this.productPage = null;
    this.staffPage = null;
    this.stockPage = null;
    this.supplyStatusPage = null;
  }

  List<Widget> getAuthorizedPages() {
    List<Widget> authorizedPages = [];

    if (analysisPage != null) authorizedPages.add(analysisPage!);
    if (carPage != null) authorizedPages.add(carPage!);
    if (deliveryPage != null) authorizedPages.add(deliveryPage!);
    if (orderPage != null) authorizedPages.add(orderPage!);
    if (personPage != null) authorizedPages.add(personPage!);
    if (productPage != null) authorizedPages.add(productPage!);
    if (staffPage != null) authorizedPages.add(staffPage!);
    if (stockPage != null) authorizedPages.add(stockPage!);
    if (supplyStatusPage != null) authorizedPages.add(supplyStatusPage!);

    return authorizedPages;
  }

  List<String> getAuthorizedPagesNames() {
    List<String> authorizedPagesNames = [];

    if (analysisPage != null) authorizedPagesNames.add("analysis");
    if (carPage != null) authorizedPagesNames.add("car");
    if (deliveryPage != null) authorizedPagesNames.add("delivery");
    if (orderPage != null) authorizedPagesNames.add("order");
    if (personPage != null) authorizedPagesNames.add("person");
    if (productPage != null) authorizedPagesNames.add("product");
    if (staffPage != null) authorizedPagesNames.add("staff");
    if (stockPage != null) authorizedPagesNames.add("stock");
    if (supplyStatusPage != null) authorizedPagesNames.add("supply status");

    return authorizedPagesNames;
  }
}
