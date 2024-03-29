import 'dart:convert';
import 'dart:ffi';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/website_screen/website_screen.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:contest_app/shared/site_list_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class DrawerNavigation extends StatefulWidget {
  DrawerNavigation({
    Key? key,
    // required this.sitesList,
  }) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  // final List sitesList;
  List sitesList = [];

  Future<void> _getSitesList() async {
    var url = "https://kontests.net/api/v1/sites";
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      sitesList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _getSitesList());
  }

  @override
  Widget build(BuildContext context) {
    //Getting user data from stream
    UserSnapshotData? user = Provider.of<UserSnapshotData?>(context);
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      elevation: 10,
      // backgroundColor: Colors.blueGrey,
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? kpurple
              : kdarkBlue,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            //DrawerHeader
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFF76F02),
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            //List of All Websites
            Expanded(
              child: ListView.builder(
                itemCount: sitesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SiteListCard(
                    sitesListData: sitesList[index],
                    user: user,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
