import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/website_screen/website_screen.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:contest_app/shared/site_list_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteBookmark extends StatefulWidget {
  // final UserSnapshotData? user;
  final String? uid;
  const WebsiteBookmark({Key? key, required this.uid}) : super(key: key);

  @override
  _WebsiteBookmarkState createState() => _WebsiteBookmarkState();
}

class _WebsiteBookmarkState extends State<WebsiteBookmark> {
  var userWebsiteList = [];

  //creating a function to get data from user
  Future _getUserBookmarkList() async {
    //creating an instance of databaseService
    DatabaseService _databaseService = DatabaseService(uid: widget.uid);
    //getting user data
    // print(await _databaseService.getUserDataMap());
    var userData = await _databaseService.getUserDataMap();
    // return userData['websites_list'];
    setState(() {
      userWebsiteList = userData['websites_list'];
    });
    // print(userWebsiteList);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _getUserBookmarkList());
  }

  @override
  Widget build(BuildContext context) {
    UserSnapshotData? user = Provider.of<UserSnapshotData?>(context);
    return ListView.builder(
      itemCount: user?.websitesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.all(8),
          elevation: 10,
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Color(0xFFF5F4F9)
              : Color(0xFF082032),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                // color: Color(0xFFF76F02),
                color: kpurple,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 17,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      user?.websitesList[index]['name'] ?? "No Name",
                      style: GoogleFonts.lato(
                        fontSize: 27,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    // Spacer(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        elevation: 3,
                        // backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Colors.white
                                : Colors.transparent,
                      ),
                      onPressed: () {
                        //changing the websiteList Map into a list
                        var siteListData = [];
                        user?.websitesList[index]
                            .forEach((key, value) => siteListData.add(value));

                        siteListData = siteListData.reversed.toList();

                        //removing the "true" before sending the data
                        siteListData.remove(true);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => WebsiteScreen(
                                      siteListData: siteListData,
                                      user: user,
                                    ))));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Open Contests Page",
                            style: TextStyle(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.open_in_new,
                            color: Color(0xFFF76F02),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        elevation: 3,
                        // backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Colors.white
                                : Colors.transparent,
                      ),
                      onPressed: () async {
                        final url = user?.websitesList[index]['website_url'];
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            "Open Website",
                            style: TextStyle(
                              fontSize: 15,
                              // color: Colors.black,
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.open_in_browser,
                            color: Color(0xFFF76F02),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
