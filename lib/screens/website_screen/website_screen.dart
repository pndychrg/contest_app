import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/models/website.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WebsiteScreen extends StatefulWidget {
  final siteListData;
  final UserSnapshotData? user;
  const WebsiteScreen(
      {Key? key, required this.siteListData, required this.user})
      : super(key: key);

  @override
  _WebsiteScreenState createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  // list of contests of the sites
  List contestDescription = [];
  Future<void> _getContestList() async {
    var url = "https://kontests.net/api/v1/" + widget.siteListData[1];
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      contestDescription = data;
    });
  }

  Map<String, dynamic> _mapFromWebsiteList(List? website) {
    if (website!.isEmpty == true) {
      return {};
    } else {
      return {
        'name': website[0],
        'underscore_name': website[1],
        'website_url': website[2]
      };
    }
  }

  Future<void> _updateContestList() async {
    //getting everything for convinience
    var user = widget.user;
    var userName = user?.name;
    var userUid = user?.uid;
    var currentWebsiteList = widget.siteListData;
    //setting up a instance of firebase
    DatabaseService _databaseService = DatabaseService(uid: userUid);
    //getting data from database as a map
    dynamic userData =
        await FirebaseFirestore.instance.collection("users").doc(userUid).get();
    userData = userData.data();

    var userWebsiteList = userData['websites_list'];

    //mapping the current webiste list data into a map
    var mapCurrent = _mapFromWebsiteList(currentWebsiteList);

    userWebsiteList.add(mapCurrent);

    //updating the websiteList in Database
    await _databaseService.updateUserData(userName, userWebsiteList);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _getContestList());
  }

  // UI required Booleans
  bool _bookmarkButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.siteListData[0],
        ),
        actions: <Widget>[
          IconButton(
            color: _bookmarkButton ? Colors.purple : Colors.white,
            icon: Icon(Icons.bookmark),
            onPressed: () async {
              setState(() {
                _bookmarkButton = !_bookmarkButton;
              });
              _updateContestList();
            },
          ),
        ],
      ),
      //main contest description views
      body: ListView.builder(
        itemCount: contestDescription.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: kPrimary,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(contestDescription[index]['name']),
                  Row(
                    children: <Widget>[
                      Text(
                        contestDescription[index]['start_time'],
                      ),
                      Spacer(),
                      Text(
                        contestDescription[index]['end_time'],
                      ),
                    ],
                  ),
                  Text(
                    "Duration: ${contestDescription[index]['duration']}",
                  ),
                  Text(
                    "In Next 24 Hours: ${contestDescription[index]['in_24_hours']}",
                  ),
                  Text(
                    "Status: ${contestDescription[index]['status']}",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
