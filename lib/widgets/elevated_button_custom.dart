import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:flutter/material.dart';

class ElevatedButtonCustom extends StatelessWidget {
  String text = "-";
  Function() onTap;

  ElevatedButtonCustom({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: blueColor,
          minimumSize: const Size(double.infinity, 56)),
      child: Text(text, style: TextStyle(color: whiteColor),));
  }
}