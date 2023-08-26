import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mazdooronline/API/LOCATION_API_HANDLER.dart';
import 'package:mazdooronline/API/USER_API_HANDLER.dart';
import 'package:mazdooronline/models/labor.dart';
import '/API/CATEGORY_API_HANDLER.dart';
import '/API/ORDER_API_HANDLER.dart';
import '/components/homescreen/circular_loader.dart';
import '/components/mapcontainer.dart';
import '/models/categories.dart';
import '/models/location.dart';
import '/models/order.dart';
import 'package:provider/provider.dart';
import '../API/CATEGORY_API_HANDLER.dart';
import '../API/ORDER_API_HANDLER.dart';
import '../components/homescreen/circular_loader.dart';
import '../components/mapcontainer.dart';
import '../models/categories.dart';
import '../models/location.dart';
import '../models/order.dart';
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
  //CurrentActiveOrder currentActiveOrder = CurrentActiveOrder();
  CategoryApiHandler api = CategoryApiHandler();
  Timer? orderCompletionChecktimer;
  late Future<void> location_data_future;
  late Future<LatLng> worker_location_future;
  late Future<LaborData> labor_detail_future;
  bool isArrived = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location_data_future = updateLocationData();
    checkOrderCompletion();
    getWorkerLocation();
    getLaborDetail();
    orderCompletionChecktimer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => checkOrderCompletion());
  }

  // Future<bool> getOrderDetail() async {
  //   OrderDetail orderDetes = await OrderApiHandler()
  //       .get_order_detail_by_id(CurrentActiveOrder().order.id);
  //   CurrentActiveOrder order = CurrentActiveOrder();
  //   order.add_order(orderDetes);
  //   return true;
  // }

  void getWorkerLocation() async {
    worker_location_future = LocationApiHandler()
        .get_labor_location(CurrentActiveOrder().order.assigned_labor_id!);
  }

  void getLaborDetail() async {
    labor_detail_future = UserApiHandler()
        .get_labor_data_by_id(CurrentActiveOrder().order.assigned_labor_id!);
  }

  void checkOrderCompletion() async {
    bool isCompleted = await OrderApiHandler().check_order_completion_status(
        CurrentActiveOrder().order.id);
    if (isCompleted) {
      orderCompletionChecktimer?.cancel();
      Navigator.pushReplacementNamed(context, '/home/bill');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: FutureBuilder<LatLng>(
        future: worker_location_future,
        builder: (context, AsyncSnapshot<LatLng> worker_LatLng) {
          if (worker_LatLng.hasData) {
            return FutureBuilder<LaborData>(
                future: labor_detail_future,
                builder:
                    (context, AsyncSnapshot<LaborData> laborDetailSnapshot) {
                  if (laborDetailSnapshot.hasData) {
                    return Column(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: FutureBuilder<void>(
                              future: location_data_future,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                                        LocationData().latitude,
                                        LocationData().longitude),
                                    //currentActiveOrder.order.creator_location_lat,
                                    //currentActiveOrder.order.creator_location_long),
                                    worker_location_: LatLng(
                                        worker_LatLng.data!.latitude,
                                        worker_LatLng.data!.longitude),
                                    labor_id: CurrentActiveOrder()
                                        .order
                                        .assigned_labor_id!,
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text("Current Job",
                                        textAlign: TextAlign.center,
                                        style: kHeadTextStyle),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                laborDetailSnapshot
                                                    .data!.full_name,
                                                //currentActiveOrder.order.creator_name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.yellow[800],
                                                    size: 18),
                                                Text(
                                                  "4.6",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                .getCategoryBaseRate(
                                                    CurrentActiveOrder()
                                                        .order
                                                        .category_id)
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
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
                                            "${DistanceCalculator.calculateDistanceinKm(LocationData().latitude, LocationData().longitude, worker_LatLng.data!.latitude, worker_LatLng.data!.longitude).toString()} km",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Description: ",
                                            style: kHeadTextStyle.copyWith(
                                                fontSize: 15),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 3,
                                          child: Text(
                                            CurrentActiveOrder().order.desc,
                                            style: kNormalTextStyle.copyWith(
                                                fontSize: 15,
                                                color: Colors.black54),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "Labor Number: ",
                                            style: kHeadTextStyle.copyWith(
                                                fontSize: 15),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          flex: 2,
                                          child: Text(
                                            laborDetailSnapshot
                                                .data!.phone_number,
                                            style: kNormalTextStyle.copyWith(
                                                fontSize: 15,
                                                color: Colors.black54),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 15,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Center(
                                      child: Text(
                                        "${laborDetailSnapshot.data!.full_name} \nis coming to your location.",
                                        style: kHeadTextStyle.copyWith(
                                            fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  // compete order button:
                                ],
                              ),
                            ),

                            // slider button
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularLoader(),
                    );
                  }
                });
          } else {
            return Center(
              child: CircularLoader(),
            );
          }
        },
      ),
    );
  }
}
