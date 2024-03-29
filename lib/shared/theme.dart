import 'package:contest_app/shared/constants.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

ThemeData ligthThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme().copyWith(
      backgroundColor: kpurple,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kdarkBlue,
    appBarTheme: AppBarTheme().copyWith(
      backgroundColor: kpurple.withOpacity(0.5),
    ),
  );
}
