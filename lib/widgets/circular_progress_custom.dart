import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:flutter/material.dart';

class CircularProgressCustom extends StatelessWidget {
  const CircularProgressCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: blueColor,
    );
  }
}