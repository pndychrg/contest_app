import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/website_screen/website_screen.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:contest_app/shared/site_list_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(user?.websitesList[index]['name']),
              Spacer(),
              IconButton(
                onPressed: () {
                  print(user?.websitesList[index]);
                  //changing the websiteList Map into a list
                  var siteListData = [];
                  user?.websitesList[index]
                      .forEach((key, value) => siteListData.add(value));
                  print(siteListData);
                  siteListData = siteListData.reversed.toList();
                  print(siteListData);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => WebsiteScreen(
                                siteListData: siteListData,
                                user: user,
                              ))));
                },
                icon: Icon(
                  Icons.link,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}
