import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget child;

  const CustomAppBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 42,
            ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blue,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SafeArea(child: child),
    );
  }
}
