import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Function() onPressed;
  final String buttonText;
  final TextStyle textStyle;
  final double buttonHeight;
  final double buttonWidth;

  CustomButton(
      {required this.buttonColor,
      required this.onPressed,
      required this.buttonText,
        this.textStyle = const TextStyle(
            color: Colors.white,
          fontSize: 18
        ),
      this.buttonHeight = 42,
      this.buttonWidth = 200});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () {
            //Implement login functionality.
            onPressed();
          },
          minWidth: buttonWidth,
          height: buttonHeight,
          child: Text(
            buttonText,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
