import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/home/home.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
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
    UserSnapshotData? user = Provider.of<UserSnapshotData?>(context);
    return RefreshIndicator(
      onRefresh: _getUserContestList,
      child: ListView.builder(
        itemCount: userContestList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: kPrimary,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(userContestList[index]['name']),
                  Row(
                    children: <Widget>[
                      Text(
                        userContestList[index]['start_time'],
                      ),
                      Spacer(),
                      Text(
                        userContestList[index]['end_time'],
                      ),
                    ],
                  ),
                  Text(
                    "Duration: ${userContestList[index]['duration']}",
                  ),
                  Text(
                    "In Next 24 Hours: ${userContestList[index]['in_24_hours']}",
                  ),
                  Text(
                    "Status: ${userContestList[index]['status']}",
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await _removeContestBookmark(userContestList[index]);
                      _getUserContestList();
                      // setState(() {});
                      // initState();
                    },
                    child: Icon(Icons.favorite),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final url = userContestList[index]['url'];
                      // final url = 'https://www.google.co.in/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: Icon(Icons.link),
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
