import 'package:flutter/material.dart';
import 'package:mazdooronline/components/user_appbar.dart';
import 'package:mazdooronline/constants.dart';
import 'package:mazdooronline/components/homescreen/popularPillBox.dart';
import 'package:mazdooronline/components/mapcontainer.dart';
import 'package:mazdooronline/location/location_handler.dart';
import 'package:mazdooronline/models/location.dart';
import 'package:mazdooronline/API/API_HANDLER.dart';
import 'package:mazdooronline/API/USER_API_HANDLER.dart';
import 'package:mazdooronline/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  late Future<bool> user_data_bool_future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateLocationData();
    getUserData();

  }

  void getUserData() async {
    UserApiHandler api = UserApiHandler();
    user_data_bool_future = api.get_user_data();
  }

  @override
  Widget build(BuildContext context) {
    return UserAppBar(
      user_data_bool_future: user_data_bool_future,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Text(
                  "Popular Options",
                  style: kHeadTextStyle,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Row(
                            children: [
                              PopularPillBox(
                                  boxColor: Color(0xFFBDF4C8),
                                  boxText: "Labour",
                                  boxHeight: 75),
                              PopularPillBox(
                                boxColor: Color(0xFFFED0AB),
                                boxText: "Plumber",
                                boxHeight: 75,
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Row(
                            children: [
                              PopularPillBox(
                                boxColor: Color(0xFFBAE5F4),
                                boxHeight: 75,
                                boxText: "Electrician",
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          height: 165,
                          margin: EdgeInsets.all(5),
                          child: Center(
                            child: Text("Masonry",
                                style: kPopularOptionsPillTextStyle),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFCECDFF),
                            borderRadius: BorderRadius.all(
                              Radius.circular(35),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/home/search');
                },
                child: Container(
                  height: 125,
                  margin: EdgeInsets.all(5),
                  child: Center(
                    child: Text("Browse all categories",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 21,
                          color: Colors.black54,
                        ),),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.all(
                      Radius.circular(35),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // TODO ADD MAP
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Text(
                  "Around you",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
              ),
              MapsCont(),
              // ADD FLOATING MENU BAR
            ],
          ),
        ),
      );
  }
}
