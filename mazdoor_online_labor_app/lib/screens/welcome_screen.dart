import 'package:flutter/material.dart';
import '/components/welcome_crousal.dart';
import '/components/appbar.dart';
import '/components/custom_button.dart';
import '/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: WelcomeImageCrousal(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 65,
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: CustomButton(
                          buttonText: "Get Started",
                          buttonColor: Colors.blue,
                          textStyle: kMainButtonTextStyle,
                          onPressed: (){
                            Navigator.pushNamed(context, '/sign-up');
                          },
                        )
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            "Existing user? Sign in",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
