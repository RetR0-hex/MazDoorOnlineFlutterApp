import 'package:flutter/material.dart';

class PasswordShowButton extends StatelessWidget {
  final Function() onpressed;
  late bool _passvisible;

  PasswordShowButton({required this.onpressed, required bool passvisible}){
    _passvisible = passvisible;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onpressed,
      icon: Icon(
        _passvisible ? Icons.visibility : Icons.visibility_off,
      ),
      color: Colors.black,
    );
  }
}
