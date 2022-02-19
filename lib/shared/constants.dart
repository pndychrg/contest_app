import 'package:flutter/material.dart';

const Color kLightBlue = Color.fromARGB(255, 146, 178, 253);
const Color kLightPurple = Color.fromARGB(255, 173, 127, 251);
const Color kLightPink = Color.fromARGB(255, 245, 148, 183);
const Color kPrimary = Color.fromARGB(255, 204, 208, 246);

final textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.pink,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
);
