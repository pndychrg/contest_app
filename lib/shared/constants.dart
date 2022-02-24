import 'package:flutter/material.dart';

const Color kLightBlue = Color.fromARGB(255, 146, 178, 253);
const Color kLightPurple = Color.fromARGB(255, 173, 127, 251);
const Color kLightPink = Color.fromARGB(255, 245, 148, 183);
const Color kPrimary = Color.fromARGB(255, 204, 208, 246);
const Color kpurple = Color(0xFF545EE1);
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

final textStyleTitle = TextStyle(
  color: Colors.black,
  fontSize: 25,
);

final outlinedButtonStyle = OutlinedButton.styleFrom(
  elevation: 3,
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);
