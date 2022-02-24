import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/home/home.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedContest extends StatefulWidget {
  final String? uid;
  const SavedContest({Key? key, required this.uid}) : super(key: key);

  @override
  _SavedContestState createState() => _SavedContestState();
}

class _SavedContestState extends State<SavedContest> {
  var userContestList = [];

  //getting data from database
  Future _getUserContestList() async {
    //creating an instance of databaseservice
    DatabaseService _databaseService = DatabaseService(uid: widget.uid);
    //getting user Data
    var userData = await _databaseService.getUserDataMap();
    //setting the data in widget
    setState(() {
      userContestList = userData['contest_list'];
    });
  }

  //Removing the ContestBookmark
  Future<void> _removeContestBookmark(dynamic contestMap) async {
    //creating an instance of databaseService
    DatabaseService _databaseService = DatabaseService(uid: widget.uid);
    //getting user Data
    var userData = await _databaseService.getUserDataMap();
    //getting contestList from userData
    var _usercontestList = userData['contest_list'];
    //removing the data
    _usercontestList.forEach((userContestListMap) {
      if (userContestListMap['name'] == contestMap['name']) {
        contestMap = userContestListMap;
      }
    });
    _usercontestList.remove(contestMap);

    //updating the data in database
    _databaseService.updateUserData(
        userData['name'], userData['websites_list'], _usercontestList);
  }

  //getting data as soon as screen is build
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _getUserContestList());
  }

  // Contest Bookmarked Button Boolean
  //bool _alreadyBookmarked = true;
  @override
  Widget build(BuildContext context) {
    // UserSnapshotData? user = Provider.of<UserSnapshotData?>(context);
    return RefreshIndicator(
      onRefresh: _getUserContestList,
      child: ListView.builder(
        itemCount: userContestList.length,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userContestList[index]['name'],
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
                        "Start time: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(userContestList[index]['start_time']))}",
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
                        "End time: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(userContestList[index]['end_time']))}",
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
                        "Duration: ${(Duration(seconds: int.parse(userContestList[index]['duration'])).inHours).toString()} Hrs",
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
                        Icons.priority_high_outlined,
                        color: Color(0xFFF76F02),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "In Next 24 Hours: ${userContestList[index]['in_24_hours']}",
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
                        "Status: ${userContestList[index]['status']}",
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
                      SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        style: outlinedButtonStyle,
                        onPressed: () async {
                          await _removeContestBookmark(userContestList[index]);
                          _getUserContestList();
                          // setState(() {});
                          // initState();
                        },
                        child: Row(
                          children: [
                            Text(
                              "Remove",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(
                              Icons.heart_broken_outlined,
                              color: Color(0xFFF76F02),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      OutlinedButton(
                        style: outlinedButtonStyle,
                        onPressed: () async {
                          final url = userContestList[index]['url'];
                          // final url = 'https://www.google.co.in/';
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              "Open Website",
                              style: TextStyle(
                                color: Colors.black,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
