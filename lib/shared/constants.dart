import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kLightBlue = Color.fromARGB(255, 146, 178, 253);
const Color kLightPurple = Color.fromARGB(255, 173, 127, 251);
const Color kLightPink = Color.fromARGB(255, 245, 148, 183);
const Color kPrimary = Color.fromARGB(255, 204, 208, 246);
const Color kpurple = Color(0xFF545EE1);
const Color kOrangeColor = Color(0xFFF76F02);
//dark theme color
const Color kdarkBlue = Color(0xFF18242B);
const Color kDarkForeground = Color(0xFF84C9FB);
final textInputDecoration = InputDecoration(
  // fillColor: MediaQuery.of(context).platformBrightness == Brightness.light
  //     ? Colors.white
  //     : kdarkBlue,
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

final textStyleTitle = GoogleFonts.lato(
  fontSize: 25,
);

final outlinedButtonStyle = OutlinedButton.styleFrom(
  elevation: 3,
  // backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
);
