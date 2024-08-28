import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon icon;
  final String hint;
  final TextInputType keyboard;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String error;
  MyTextField({required this.label, this.maxLines = 1, this.minLines = 1, required this.icon,required this.controller,required this.hint,required this.keyboard,required this.error,required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: icon == null ? null: icon,
          labelText: label,
          errorText: error,
          labelStyle: TextStyle(color: Colors.white),
          hintText: hint,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70))),
    );
  }
}