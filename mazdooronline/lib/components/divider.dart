import 'package:flutter/material.dart';

class _CustomDivider extends StatelessWidget {
  const _CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        endIndent: 2,
        color: Colors.black26,
        thickness: 1,
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children:  [
        _CustomDivider(),
        Text(
          text,
          style: TextStyle(
            color: Colors.black26,
          ),
        ),
        _CustomDivider(),
      ]),
    );

  }
}
