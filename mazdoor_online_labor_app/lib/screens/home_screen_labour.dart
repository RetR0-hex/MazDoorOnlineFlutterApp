import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../components/mapcontainer.dart';
import '../main.dart';
import '../models/location.dart';
import '../models/order.dart';
import '/components/user_appbar.dart';
import '/constants.dart';
import '/API/USER_API_HANDLER.dart';
import '/API/ORDER_API_HANDLER.dart';
import "/components/homescreen/circular_loader.dart";
import 'dart:async';
import '/location/location_handler.dart';
import '/models/order.dart';
import '/route_observer/route_observer.dart';

class LaborHome extends StatefulWidget {
  @override
  State<LaborHome> createState() => _LaborHomeState();
}

class _LaborHomeState extends State<LaborHome> with RouteAware{
  List<Widget> text = [
    Text("Online",
        style: kMainButtonTextStyle.copyWith(color: Colors.green[700])),
    Text("Offline",
        style: kMainButtonTextStyle.copyWith(color: Colors.red[400]))
  ];
  late Future<bool> is_user_data_here;
  late Future<bool> orders_data_status;

  ActiveOrdersList actveOrder = ActiveOrdersList();

  List<bool> _selectedOption = [true, false];

  Timer? timer_active_orders, timer_update_location;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }


  @override
  void initState() {
    super.initState();
    getUserData();
    getActiveOrders();
    updateLocationData();
    timer_active_orders =
        Timer.periodic(Duration(seconds: 15), (Timer t) => getActiveOrders());
    timer_update_location =
        Timer.periodic(Duration(seconds: 60), (Timer t) => updateLocationData());
  }


  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    timer_active_orders!.cancel();
    timer_update_location!.cancel();
    super.dispose();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    timer_active_orders!.cancel();
    timer_update_location!.cancel();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    timer_active_orders =
        Timer.periodic(Duration(seconds: 15), (Timer t) => getActiveOrders());
    timer_update_location =
        Timer.periodic(Duration(seconds: 60), (Timer t) => updateLocationData());
  }





  void getUserData() async {
    UserApiHandler api = UserApiHandler();
    is_user_data_here = api.get_user_data();
  }

  void getActiveOrders() async {
    if (_selectedOption[0] == true) {
      OrderApiHandler api = OrderApiHandler();
      orders_data_status = api.get_list_of_active_orders();
    } else {
      setState(() {
        actveOrder.active_orders.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserAppBar(
      user_data_bool_future: is_user_data_here,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedOption.length; i++) {
                      _selectedOption[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.blue[400],
                selectedColor: Colors.white,
                fillColor: Colors.blue[200],
                color: Colors.blue[200],
                constraints: const BoxConstraints(
                  minHeight: 120,
                  minWidth: 120,
                ),
                isSelected: _selectedOption,
                children: text,
              ),
            ),
          ),
          FutureBuilder<bool>(
              future: orders_data_status,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      flex: 4,
                      child: Consumer<ActiveOrdersList>(
                          builder: (context, actveOrder, child) {
                        return Column(
                          children: [
                            Text("Acceptable Orders", style: kHeadTextStyle),
                            SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF8F3F7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: actveOrder.active_orders.isEmpty
                                    ? NoActiveTask()
                                    : CurrentActiveTask(
                                        activeOrder: actveOrder,
                                      ),
                              ),
                            )
                          ],
                        );
                      })
                      // TODO HERE WILL BE A LIST OF TASKS THEY CAN ACCEPT
                      );
                } else {
                  return CircularLoader();
                }
              })
          // if tasks are empty show a
          // a different widget
        ],
      ),
    );
  }
}

class CurrentActiveTask extends StatelessWidget {
  late ActiveOrdersList activeOrder;

  CurrentActiveTask({required this.activeOrder});

  @override
  Widget build(BuildContext context) {
    // card widget that shows info of Active Order
    return ListView.builder(
        itemCount: activeOrder.active_orders.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return IntrinsicHeight(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                  child: HorizontalCard(
                      activeOrder: activeOrder.active_orders[index])),
            ]),
          );
        });
  }
}

class HorizontalCard extends StatelessWidget {
  late Order activeOrder;

  HorizontalCard({required this.activeOrder});
  final Color color = Color(0xff4C4B63);
  final Color textColor = Color(0xffFFECCC);
  final Image image = Image.asset('assets/images/bottom-cloud.png');

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (context) => ShowOrderInformation(order: activeOrder),
              );
            },
            child: Card(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        child: image,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(28, 55, 0, 0),
                      child: Text(
                        activeOrder.category_name,
                        style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontFamily: 'MontserratRegular'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 24, 0, 0),
                      child: Text(
                        activeOrder.desc,
                        style: TextStyle(
                            fontSize: 22,
                            color: textColor,
                            fontFamily: 'MontserratBold'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(240, 26, 10, 0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff232238)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          CurrentActiveOrder current_active_order = CurrentActiveOrder();
                          OrderApiHandler api = OrderApiHandler();
                          OrderDetail orderDetail = await api.get_order_detail_by_id(activeOrder.id);
                          current_active_order.add_order(orderDetail);
                          await api.accept_active_order_by_id(orderDetail.id);
                          Navigator.pushReplacementNamed(context, "/home/order");
                        },
                        child: Text(
                          "Accept",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}

class ShowOrderInformation extends StatefulWidget {
  late final Order order;

  ShowOrderInformation({required this.order});

  @override
  State<ShowOrderInformation> createState() => _ShowOrderInformationState();
}

class _ShowOrderInformationState extends State<ShowOrderInformation> {
  late Future<OrderDetail> order_detail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetailData(widget.order.id);
  }

  void getOrderDetailData(int order_id) async {
    OrderApiHandler api = OrderApiHandler();
    order_detail = api.get_order_detail_by_id(order_id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: order_detail,
      builder: (BuildContext context, AsyncSnapshot<OrderDetail> snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            title: Text(
              'Order Information',
              textAlign: TextAlign.center,
              style: kHeadTextStyle,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.zero,
            content: Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Divider(
                      color: Colors.black87,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Material(
                                  elevation: 2,
                                  child: Container(
                                    child: MapsCont(
                                      cords: LatLng(
                                          snapshot.data!.creator_location_lat,
                                          snapshot.data!.creator_location_long),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Category: ",
                                          style: kNormalTextStyle,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${snapshot.data!.category_name}",
                                          style: kNormalTextStyle.copyWith(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Description: ",
                                          style: kNormalTextStyle,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${snapshot.data!.desc}",
                                          style: kNormalTextStyle.copyWith(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Customer Name: ",
                                          style: kNormalTextStyle,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${snapshot.data!.creator_name}",
                                          style: kNormalTextStyle.copyWith(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Phone Number: ",
                                          style: kNormalTextStyle,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${snapshot.data!.creator_phone}",
                                          style: kNormalTextStyle.copyWith(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            // google map widget
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Accept'),
                onPressed: () async {
                  CurrentActiveOrder current_active_order = CurrentActiveOrder();
                  current_active_order.add_order(snapshot.data!);
                  OrderApiHandler api = OrderApiHandler();
                  await api.accept_active_order_by_id(snapshot.data!.id);
                  Navigator.pushReplacementNamed(context, "/home/order");
                },
              ),
              TextButton(
                child: Text('Decline'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        return Center(
          child: CircularLoader(),
        );
      },
    );
  }
}

class NoActiveTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              color: Colors.amber,
              size: 100,
            ),
            Text(
              "No active orders available.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.amber, fontSize: 24, fontWeight: FontWeight.w400),
            ),

          ],
        ),
      ),
    );
  }
}
