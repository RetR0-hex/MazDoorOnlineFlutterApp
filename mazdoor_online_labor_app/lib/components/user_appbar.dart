import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/models/user.dart';
import 'package:provider/provider.dart';
import '/models/role.dart';

class UserAppBar extends StatefulWidget {
  final Widget child;
  final Future<bool> user_data_bool_future;

  const UserAppBar({required this.child, required this.user_data_bool_future});

  @override
  State<UserAppBar> createState() => _UserAppBarState();
}

class _UserAppBarState extends State<UserAppBar> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: widget.user_data_bool_future,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            EasyLoading.dismiss();
            return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  leading: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 20.0,
                          child: const Text(
                              'NA'), // TODO make this chnage according ot user name
                        ),
                      ],
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        UserData().full_name,
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        roles[UserData().role],
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  // UserName
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.blue,
                  elevation: 0.0,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.add_alert_outlined),
                    ),
                  ],
                ),
                body: SafeArea(
                  child: widget.child,
                )
            );
          }
          else {
            EasyLoading.show(status: "loading....");
            return SizedBox.shrink();
          }
        }
    );
  }
}
