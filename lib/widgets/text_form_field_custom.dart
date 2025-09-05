import 'package:afila_intern_presence/common/app_colors.dart';
import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String label = "-";
  bool obscureText = false;
  bool isEnabled = true;
  TextInputType textInputType;

  TextFormFieldCustom({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.isEnabled = true,
    this.textInputType = TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 12),
      controller: controller,
      cursorColor: blueColor,
      obscureText: obscureText,
      enabled: isEnabled,
      keyboardType: textInputType,
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(color: blueColor),
        labelStyle: TextStyle(fontSize: 12,),
        label: Text(label),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blueColor)
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey))),
    );
  }
}