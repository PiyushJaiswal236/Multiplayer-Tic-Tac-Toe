import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  List<Shadow> shadows;
  final String text;
  final double fontSize;

  CustomText(
      {super.key,
      required this.shadows,
      required this.text,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(fontSize: fontSize, shadows: shadows, color: Colors.white),
    );
  }
}
