import 'dart:ffi';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/services/api_connect.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerNavigation extends StatelessWidget {
  DrawerNavigation({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //Getting user data from stream
    UserSnapshotData? user = Provider.of<UserSnapshotData?>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          //DrawerHeader
          DrawerHeader(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: kLightPurple,
                  child: Text(
                    user?.name[0] ?? "-",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  user?.name ?? "No Name",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          //List of All Websites
          Divider(),
        ],
      ),
    );
  }
}
