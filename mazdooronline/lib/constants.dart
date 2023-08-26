import 'package:flutter/material.dart';

final kCustomTheme = ThemeData().copyWith(
    colorScheme: ThemeData().colorScheme.copyWith(
        secondary: const Color(0x002196f3)
    )
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kInputBoxDecoration = InputDecoration(
    icon: null,
    focusColor: Colors.black,
    fillColor: Colors.black,
    hintText: '',
    hintStyle: TextStyle(
        color: Colors.black26
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: InputBorder.none,
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black26)
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        )
    )
);

var kMainButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.blue)))
);

const kMainButtonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 25
);

const kLoginScreenTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 46,
  fontWeight: FontWeight.w900,
);

const kPopularOptionsPillTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.black54,
    fontWeight: FontWeight.w500
);

const kHeadTextStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 24,
);

const kNormalTextStyle = TextStyle(
  fontSize: 15,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);
