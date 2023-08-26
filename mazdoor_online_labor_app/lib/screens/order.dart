import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mazdoor_online_labor_app/API/CATEGORY_API_HANDLER.dart';
import 'package:mazdoor_online_labor_app/API/ORDER_API_HANDLER.dart';
import 'package:mazdoor_online_labor_app/components/homescreen/circular_loader.dart';
import 'package:mazdoor_online_labor_app/components/mapcontainer.dart';
import 'package:mazdoor_online_labor_app/models/categories.dart';
import 'package:mazdoor_online_labor_app/models/location.dart';
import 'package:mazdoor_online_labor_app/models/order.dart';
import 'package:provider/provider.dart';
import '/constants.dart';
import 'dart:async';
import '/location/location_handler.dart';
import '/location/diatance_calculator.dart';
import '/components/custom_button.dart';
import '/components/slider_button.dart';

class OrderScreen extends StatefulWidget {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  CurrentActiveOrder currentActiveOrder = CurrentActiveOrder();
  CategoryApiHandler api = CategoryApiHandler();
  Timer? locationTimer;
  late Future<void> location_data_future;
  late Future<bool> category_data_status;
  bool isArrived = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location_data_future = updateLocationData();
    getCategoryData();
  }

  void getCategoryData() async {
    category_data_status = api.get_categories();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: FutureBuilder<void>(
                future: location_data_future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularLoader(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error"),
                    );
                  } else {
                    return NavigationMapContainer(
                      client_location_: LatLng(
                          currentActiveOrder.order.creator_location_lat,
                          currentActiveOrder.order.creator_location_long),
                      worker_location_: LatLng(
                          LocationData().latitude, LocationData().longitude),
                    );
                  }
                }),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: PhysicalModel(
              color: Colors.white,
              elevation: 20,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Current Order",
                          textAlign: TextAlign.center, style: kHeadTextStyle),
                    ),
                    Divider(
                      thickness: 1,
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 20.0,
                          child: const Text(
                              'NA'), // TODO make this chnage according ot user name
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentActiveOrder.order.creator_name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.yellow[800], size: 18),
                                  Text(
                                    "4.6",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.black45),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FutureBuilder<bool>(
                          future: category_data_status,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rate/hr",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    Categories()
                                        .getCategoryBaseRate(currentActiveOrder
                                            .order.category_id)
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return CircularLoader();
                            }
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Text(
                              "Total Distance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${DistanceCalculator.calculateDistanceinKm(currentActiveOrder.order.creator_location_lat, currentActiveOrder.order.creator_location_long, LocationData().latitude, LocationData().longitude).toString()} km",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      height: 25,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Description: ",
                              style: kHeadTextStyle.copyWith(fontSize: 15),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 3,
                            child: Text(
                              currentActiveOrder.order.desc,
                              style: kNormalTextStyle.copyWith(
                                  fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Customer Number: ",
                              style: kHeadTextStyle.copyWith(fontSize: 15),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 2,
                            child: Text(
                              currentActiveOrder.order.creator_phone,
                              style: kNormalTextStyle.copyWith(
                                  fontSize: 12, color: Colors.black54),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 25,
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          "You are on the way to \n ${currentActiveOrder.order.creator_name}",
                          style: kHeadTextStyle.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    Divider(
                      thickness: 1,
                      height: 25,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // has arrived button
                          Visibility(
                            visible: !isArrived,
                            child: SlideActionBtn(
                                onSlide: () {
                                  setState(() {
                                    isArrived = true;
                                  });
                                },
                                label: "Confirm Arrival at location"),
                          ),
                          // compete order button
                          Visibility(
                            visible: isArrived,
                            child: SlideActionBtn(
                                onSlide: () async {
                                  OrderApiHandler order_api = OrderApiHandler();
                                  try {
                                    await order_api.complete_order_by_id(
                                        CurrentActiveOrder().order.id);
                                    Navigator.pushReplacementNamed(
                                        context, '/home/bill');
                                  } catch (e) {
                                    EasyLoading.showInfo(e.toString());
                                  }
                                },
                                label: "Confirm Completion of order"),
                          )
                        ],
                      ),
                    ),

                    // slider button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
