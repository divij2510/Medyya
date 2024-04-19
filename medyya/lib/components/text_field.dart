import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.grey[50],
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.blueGrey[200],
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusColor: Colors.pink[200],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 3,
            color: Colors.pink.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
              width:2.2,
            color: Colors.pink.shade100,)
        ),
      ),
    );
  }
}
