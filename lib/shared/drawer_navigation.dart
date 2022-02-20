import 'dart:convert';
import 'dart:ffi';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/website_screen/website_screen.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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
    print("Function has ran");
    print(data);
    setState(() {
      sitesList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    print("initstate ran");
    WidgetsBinding.instance?.addPostFrameCallback((_) => _getSitesList());
  }

  @override
  Widget build(BuildContext context) {
    //Getting user data from stream
    UserSnapshotData? user = Provider.of<UserSnapshotData?>(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          //DrawerHeader
          DrawerHeader(
            decoration: BoxDecoration(
              color: kLightPink,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
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
          Expanded(
            child: ListView.builder(
              itemCount: sitesList.length,
              itemBuilder: (BuildContext context, int index) {
                return SiteListCard(
                  sitesList: sitesList,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SiteListCard extends StatelessWidget {
  final int index;
  const SiteListCard({
    Key? key,
    required this.sitesList,
    required this.index,
  }) : super(key: key);

  final List sitesList;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPrimary,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  sitesList[index][0],
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    letterSpacing: 2,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.link_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => WebsiteScreen(
                                siteListData: sitesList[index]))));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            // Text(sitesList[index][2]),
          ],
        ),
      ),
    );
  }
}
