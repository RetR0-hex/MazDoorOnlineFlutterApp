import 'package:flutter/material.dart';

import "/constants.dart";

class CircularLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20,),
            Text("Loading....",
              style: kHeadTextStyle.copyWith(
                fontSize: 25,
              ),)
          ],
        )
    );
  }
}
