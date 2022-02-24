import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/models/website.dart';
import 'package:contest_app/services/add_calendar.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  //creating a function to add bookmark
  Future<void> _updateWebsiteListAdd() async {
    //getting everything for convinience
    var user = widget.user;
    var userName = user?.name;
    var userUid = user?.uid;
    var userContestList = user?.contestList;
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
    await _databaseService.updateUserData(
        userName, userWebsiteList, userContestList);
  }

  //creating a function to remove the bookmark
  Future<void> _updateWebsiteListDel() async {
    //getting everything for convinience
    var user = widget.user;
    var userName = user?.name;
    var userUid = user?.uid;
    var userContestList = user?.contestList;

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
    await _databaseService.updateUserData(
        userName, userWebsiteList, userContestList);
  }

  //creating a function to add contest bookmark
  dynamic _updateContestList(dynamic ContestMap) async {
    //getting everything for convinience
    var user = widget.user;
    var userName = user?.name;
    var userUid = user?.uid;
    var userContestList = user?.contestList;
    var userWebsiteList = user?.websitesList;

    //setting up a instance of firebase
    DatabaseService _databaseService = DatabaseService(uid: userUid);
    bool alreadyFound = false;
    // as the data is already a map
    //we will add it directly
    //but before adding we will check if it is already saved
    userContestList?.forEach((contest) {
      if (contest['name'] == ContestMap['name']) {
        alreadyFound = true;
      }
    });
    // userContestList?.add(ContestMap);
    if (alreadyFound == true) {
      // print("Already Found == true");
      return alreadyFound;
    } else {
      // print("Not Found");
      //add data as it is not already found
      userContestList?.add(ContestMap);
      //let's push this into the data
      await _databaseService.updateUserData(
          userName, userWebsiteList, userContestList);
      return alreadyFound;
    }
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

  //snackbar for showing results
  SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
      duration: Duration(seconds: 1),
      dismissDirection: DismissDirection.horizontal,
    );
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
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     widget.siteListData[0],
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //       color: _bookmarkButton ? Colors.purple : Colors.white,
        //       icon: Icon(Icons.bookmark),
        //       onPressed: () async {
        //         // _updateContestList();
        //         if (_bookmarkButton == false) {
        //           await _updateWebsiteListAdd();
        //           setState(() {
        //             _bookmarkButton = !_bookmarkButton;
        //           });
        //         } else {
        //           //Now as it is already saved we have to remove it from saved.
        //           await _updateWebsiteListDel();
        //           // print("Already saved");
        //           setState(() {
        //             _bookmarkButton = !_bookmarkButton;
        //           });
        //         }
        //       },
        //     ),
        //   ],
        // ),
        // //main contest description views
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: kpurple,
              ),
              height: 60,
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x080a0928),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    widget.siteListData[0],
                    style: textStyleTitle.copyWith(color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                    color: _bookmarkButton ? Color(0xFFF76F02) : Colors.white,
                    icon: Icon(Icons.bookmark),
                    onPressed: () async {
                      // _updateContestList();
                      if (_bookmarkButton == false) {
                        await _updateWebsiteListAdd();
                        setState(() {
                          _bookmarkButton = !_bookmarkButton;
                        });
                      } else {
                        //Now as it is already saved we have to remove it from saved.
                        await _updateWebsiteListDel();
                        // print("Already saved");
                        setState(() {
                          _bookmarkButton = !_bookmarkButton;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contestDescription.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10.0,
                    margin: EdgeInsets.all(8),
                    color: Color(0xFFF5F4F9),
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
                          Text(
                            contestDescription[index]['name'],
                            style: textStyleTitle,
                            maxLines: 2,
                          ),
                          Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.av_timer,
                                color: Color(0xFFF76F02),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Start time: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(contestDescription[index]['start_time']))}",
                                style: textStyleTitle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.av_timer,
                                color: Color(0xFFF76F02),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "End time: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(contestDescription[index]['end_time']))}",
                                style: textStyleTitle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: Color(0xFFF76F02),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Duration: ${(Duration(seconds: int.parse(contestDescription[index]['duration'])).inHours).toString()} Hrs",
                                style: textStyleTitle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.priority_high_outlined,
                                color: Color(0xFFF76F02),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "In Next 24 Hours: ${contestDescription[index]['in_24_hours']}",
                                style: textStyleTitle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.contactless_outlined,
                                color: Color(0xFFF76F02),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Status: ${contestDescription[index]['status']}",
                                style: textStyleTitle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              OutlinedButton(
                                style: outlinedButtonStyle,
                                onPressed: () async {
                                  final url = contestDescription[index]['url'];
                                  // final url = 'https://www.google.co.in/';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Open Website",
                                      style: textStyleTitle.copyWith(
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Icon(
                                      Icons.link,
                                      color: Color(0xFFF76F02),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                style: outlinedButtonStyle,
                                onPressed: () async {
                                  var contestUpdate = await _updateContestList(
                                      contestDescription[index]);
                                  if (contestUpdate == true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar("Not Updated"));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        snackBar("Added Successfully"));
                                  }
                                  // print(contestUpdate == true);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      color: Color(0xFFF76F02),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              OutlinedButton(
                                style: outlinedButtonStyle.copyWith(),
                                onPressed: () {
                                  //getting all values together
                                  var title = contestDescription[index]['name'];
                                  var startDate =
                                      contestDescription[index]['start_time'];
                                  var endDate =
                                      contestDescription[index]['end_time'];
                                  //changing datatype of dates
                                  startDate = DateTime.parse(startDate);
                                  endDate = DateTime.parse(endDate);
                                  print(startDate);
                                  print(endDate);
                                  AddCalendar addCalendar = AddCalendar();
                                  addCalendar.addToCalendar(
                                      title, startDate, endDate);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFFF76F02),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "Add Event to Calendar",
                                      style: textStyleTitle.copyWith(
                                        fontSize: 17,
                                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
