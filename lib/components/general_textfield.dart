import 'package:flutter/material.dart';

class GeneralTextField extends StatelessWidget {
  final Function onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  final TextEditingController controller;

  GeneralTextField({
    @required this.onChanged,
    @required this.keyboardType,
    @required this.obscureText,
    @required this.hintText,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
          fontSize: 14.0,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 10.0,
        ),
      ),
    );
  }
}
