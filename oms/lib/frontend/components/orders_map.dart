import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oms/frontend/model/place.dart';

class OrdersMap extends StatefulWidget {
  OrdersMap({super.key, required this.warehouse, required this.ordersFromId});
  WarehouseInfo warehouse;
  Map<String, OrderInfo> ordersFromId;

  @override
  State<OrdersMap> createState() => _OrdersMapState();
}

class _OrdersMapState extends State<OrdersMap> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};

  void onMapCreated(GoogleMapController controller) {
    int counter = 0;
    setState(() {
      _controller.complete(controller);
      _markers = (widget.ordersFromId.entries.map((entry) {
                counter++;
                return Marker(
                    markerId: MarkerId(counter.toString()),
                    position: entry.value.location,
                    infoWindow: InfoWindow(
                        title: "Id: " + entry.key + " - " + entry.value.name,
                        snippet: "Tel. no: " + entry.value.telephone));
              }).toList() +
              [
                Marker(
                  markerId: MarkerId((counter+1).toString()),
                  position: widget.warehouse.location,
                  infoWindow: InfoWindow(title: "Warehouse id: " + widget.warehouse.id),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                )
              ])
          .toSet();
    });
    print(_markers);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.warehouse.location,
        zoom: 14,
      ),
      markers: _markers,
      onMapCreated: onMapCreated,
    );
  }
}
