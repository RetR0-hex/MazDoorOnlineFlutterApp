import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mazdooronline/constants.dart';
import 'package:mazdooronline/API/CATEGORY_API_HANDLER.dart';
import 'dart:async';
import 'package:mazdooronline/API/ORDER_API_HANDLER.dart';
import 'package:mazdooronline/API/USER_API_HANDLER.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mazdooronline/components/custom_button.dart';
import 'package:mazdooronline/models/categories.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mazdooronline/components/user_appbar.dart';
import 'package:mazdooronline/location/location_handler.dart';
import 'package:mazdooronline/models/location.dart';
import 'package:mazdooronline/API/API_HANDLER.dart';

import '../components/mapcontainer.dart';
import '../models/order.dart';

class Hiring extends StatefulWidget {
  const Hiring({Key? key}) : super(key: key);

  @override
  State<Hiring> createState() => _HiringState();
}

class _HiringState extends State<Hiring> {
  // TODO GET CATEGORIES FROM REST API

  late Future<bool> category_data_bool;
  late Future<bool> user_data_bool_future;

  final List<AssetImage> icons = [
    AssetImage("assets/tools_icons/hammer.png"),
    AssetImage("assets/tools_icons/saw.png"),
    AssetImage("assets/tools_icons/pliers.png"),
    AssetImage("assets/tools_icons/wrench.png"),
    AssetImage("assets/tools_icons/spade.png"),
    AssetImage("assets/tools_icons/brush.png"),
    AssetImage("assets/tools_icons/brush.png"),
    AssetImage("assets/tools_icons/welder.png"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateLocationData();
    get_categories_data();
    getUserData();
  }

  void get_categories_data() async {
    CategoryApiHandler api = CategoryApiHandler();
    category_data_bool = api.get_categories(icons);
  }

  void getUserData() async {
    UserApiHandler api = UserApiHandler();
    user_data_bool_future = api.get_user_data();
  }

  final cat = Categories();
  int selected_category_id = 0;
  String desc = "";

  Color cardColor = Colors.white54;

  @override
  Widget build(BuildContext context) {
    return UserAppBar(
      user_data_bool_future: user_data_bool_future,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CenteredMapContainer(
                  user_location:
                      LatLng(LocationData().latitude, LocationData().longitude),
                )),
          ),
          FutureBuilder<bool>(
              future: category_data_bool,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  EasyLoading.dismiss();
                  return Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: cat.categories.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: HiringCard(
                                        image: cat.categories[index].icon,
                                        category_name:
                                            cat.categories[index].name,
                                        base_rate: cat
                                            .categories[index].baseRate
                                            .toString(),
                                        ontap: () {
                                          setState(() {
                                            for (int i = 0;
                                                i < cat.categories.length;
                                                i++) {
                                              cat.categories[i].isSelected =
                                                  false;
                                            }
                                            cat.categories[index].isSelected =
                                                !cat.categories[index]
                                                    .isSelected;
                                            selected_category_id =
                                                cat.categories[index].id;
                                          });
                                        },
                                        isSelected:
                                            cat.categories[index].isSelected),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              onChanged: (value) {
                                //Do something with the user input.
                                desc = value;
                              },
                              decoration: kInputBoxDecoration.copyWith(
                                hintText: "Enter Description of your problem",
                                icon: Icon(Icons.help),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: CustomButton(
                              buttonColor: (Colors.blue[300])!,
                              onPressed: () async {
                                try {
                                  OrderApiHandler api = OrderApiHandler();
                                  CurrentActiveOrder current_active_order = CurrentActiveOrder();
                                  int orderId = await api.create_new_order(selected_category_id, desc);
                                  OrderDetail orderDetail = await api.get_order_detail_by_id(orderId);
                                  current_active_order.add_order(orderDetail);
                                  Navigator.pushReplacementNamed(
                                      context, '/home/waiting');
                                } catch (e) {
                                  EasyLoading.showInfo(e.toString());
                                }
                              },
                              buttonText: "Hire Now!",
                              buttonHeight: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  EasyLoading.show(status: "loading....");
                  return SizedBox.shrink();
                }
              }),
        ],
      ),
    );
  }
}

class HiringCard extends StatelessWidget {
  final AssetImage image;
  final String category_name;
  final String base_rate;
  final Function() ontap;
  bool isSelected;

  HiringCard(
      {required this.image,
      required this.category_name,
      required this.base_rate,
      required this.ontap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 150,
          width: 150,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            color: isSelected ? Colors.blue[200] : Colors.white54,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Image(
                    image: image,
                    height: 50,
                    width: 50,
                  ),
                ),
                SizedBox(height: 5),
                Flexible(
                  child: Text(category_name,
                      textAlign: TextAlign.center,
                      style:
                          kPopularOptionsPillTextStyle.copyWith(fontSize: 15)),
                ),
                SizedBox(height: 5),
                Flexible(
                    child: Text(
                  "Rate/hr $base_rate",
                  style: kHeadTextStyle.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
