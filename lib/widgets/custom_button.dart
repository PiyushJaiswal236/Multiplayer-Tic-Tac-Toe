import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const CustomButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(minimumSize: Size(width, 50),padding: const EdgeInsets.symmetric(vertical: 15)),
      child: Text(text,style: const TextStyle(fontSize: 19),),
    );
  }
}
