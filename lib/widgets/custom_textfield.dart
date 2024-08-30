import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final isReadOnly;
  const CustomTextfield({super.key, required this.controller, required this.hintText, this.isReadOnly=false});

  @override
  Widget build(Object context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(
          color: Colors.blue,
          blurRadius: 5,
          spreadRadius: 2
        )]
      ),
      child: TextField(
        readOnly: isReadOnly,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: bgColor,
          filled: true,
        ),
      ),
    );
  }
}
