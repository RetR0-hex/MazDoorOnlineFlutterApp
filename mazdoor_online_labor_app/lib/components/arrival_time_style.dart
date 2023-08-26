import 'package:flutter/material.dart';


class ArrivalTimeStyle extends StatelessWidget {
  const ArrivalTimeStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.try_sms_star_sharp,
                size: 25, color: Colors.blue[400]),
            SizedBox(
              width: 15,
            ),
            Text(
              "Arrival Time",
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
                child:
                SizedBox()), // moves the comming element to most right
            Text(
              "09:47",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.try_sms_star_sharp,
                size: 25, color: Colors.black),
            SizedBox(
              width: 15,
            ),
            Text(
              "Completion Time",
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
                child:
                SizedBox()), // moves the comming element to most right
            Text(
              "10:47",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
