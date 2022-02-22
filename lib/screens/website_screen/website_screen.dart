import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/models/website.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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

  //mapping the websiteListData to a Map of String,dynamic
  Map<String, dynamic> _mapFromWebsiteList(List? website) {
    if (website!.isEmpty == true) {
      return {};
    } else {
      return {
        'name': website[0],
        'underscore_name': website[1],
        'website_url': website[2],
        'saved': true,
      };
    }
  }

  Future<void> _updateContestListAdd() async {
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

  //creating a function to remove the bookmark
  Future<void> _updateContestListDel() async {
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
    //getting only the website list from the data
    var userWebsiteList = userData['websites_list'];
    //mapping the current webiste list data into a map
    var mapCurrent = _mapFromWebsiteList(currentWebsiteList);
    print(mapCurrent);
    print(userWebsiteList);
    // as the website is already in the data we have to remove it
    //writing a loop to remove data
    userWebsiteList.forEach((websiteMap) {
      if (websiteMap['name'] == mapCurrent['name']) {
        //direct removal is not happening cause of different map series
        //so we are finding the map inside the data from firebase and if is found
        //then we are saving it in our current map
        mapCurrent = websiteMap;
      }
    });
    //here we are deleting our current map
    userWebsiteList.remove(mapCurrent);
    //here we are updating the data in firebase
    await _databaseService.updateUserData(userName, userWebsiteList);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _getContestList());
  }

  // UI required Booleans
  bool _bookmarkButton = false;

  _checkIfAlreadySaved() {
    bool _returnVal = false;
    var websiteListFromWidget = widget.siteListData;
    var websiteListFromUser = widget.user?.websitesList;
    // this function is iterating the userWebsiteList from the firebase and checking
    // if it contains a Map with name same as name from websiteList given from widget
    //returning true if it contains it or else returning false.
    websiteListFromUser?.forEach((websiteMap) {
      if (websiteMap['name'] == websiteListFromWidget[0]) {
        // print('found');
        _returnVal = true;
      }
    });
    return _returnVal;
  }

  @override
  Widget build(BuildContext context) {
    //this function will save the value of boolean in variable
    var checkIfAlreadySaved = _checkIfAlreadySaved();
    // this if statement will check if the page is already saved or not and then
    //will color the Bookmarking icon on that condition
    if (checkIfAlreadySaved == true) {
      setState(() {
        _bookmarkButton = true;
      });
    }
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
              // _updateContestList();
              if (_bookmarkButton == false) {
                await _updateContestListAdd();
                setState(() {
                  _bookmarkButton = !_bookmarkButton;
                });
              } else {
                //Now as it is already saved we have to remove it from saved.
                await _updateContestListDel();
                // print("Already saved");
                setState(() {
                  _bookmarkButton = !_bookmarkButton;
                });
              }
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
