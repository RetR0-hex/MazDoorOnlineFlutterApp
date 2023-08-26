import 'package:flutter/material.dart';
import 'package:mazdooronline/constants.dart';

class PopularPillBox extends StatelessWidget {
  final Color boxColor;
  final String boxText;
  final double boxHeight;

  PopularPillBox({required this.boxColor, required this.boxText, required this.boxHeight});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          // TODO IMPLEMENT THIS LATER I HOPE
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            height: boxHeight,
            child: Center(
              child: Text(
                boxText,
                style: kPopularOptionsPillTextStyle,
              ),
            ),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
