import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class SlideActionBtn extends StatelessWidget {
  late Function() onSlide;
  late String label;

  SlideActionBtn({required this.onSlide, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SliderButton(
            width: MediaQuery.of(context).size.width * 0.9,
            action: onSlide,
            label: Text(
              label,
              style: TextStyle(
                  color: Color(0xff4a4a4a),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            icon: Text(
              "X",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 35,
              ),
            ),
            buttonColor: Colors.blue,
            backgroundColor: Colors.black12,
          ),
        ],
      ),
    );
  }
}
