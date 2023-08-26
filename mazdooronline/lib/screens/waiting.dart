import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mazdooronline/API/ORDER_API_HANDLER.dart';
import 'package:mazdooronline/models/order.dart';

import '../route_observer/route_observer.dart';

class WaitingScreen extends StatefulWidget {
  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> with RouteAware {
  Timer? orderStatusUpdateTimer;
  late OrderDetail orderDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderStatus();
    orderStatusUpdateTimer =
        Timer.periodic(Duration(seconds: 15), (Timer t) => getOrderStatus());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  void getOrderStatus() async {
    OrderApiHandler api = OrderApiHandler();
    bool orderStatus = await api.get_active_order_status();
    if (orderStatus) {
      orderDetails = await api.get_order_detail_by_id(CurrentActiveOrder().order.id);
      CurrentActiveOrder().add_order(orderDetails);
      if (context.mounted) Navigator.pushReplacementNamed(context, '/home/order');
    }
  }

  void dispose() {
    orderStatusUpdateTimer!.cancel();
    super.dispose();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    orderStatusUpdateTimer!.cancel();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    orderStatusUpdateTimer =
        Timer.periodic(Duration(seconds: 15), (Timer t) => getOrderStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            // animated please wait text
            Text(
              "Please wait...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Waiting for a labor to accept \nyour order...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
