import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/home/saved_contest.dart';
import 'package:contest_app/screens/home/view_contest.dart';
import 'package:contest_app/services/auth.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:contest_app/shared/drawer_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contest_app/services/api_connect.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //instance of authentication service
  final AuthService _auth = AuthService();

  getSitesList() async {
    //getting sites list from api
    ContestSites _api = ContestSites();
    var list = await _api.getSitesList();
    return list;
  }

  var list;
  @override
  void initState() {
    super.initState();
    getSitesList();
    // print(list);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    return StreamProvider<UserSnapshotData?>.value(
      initialData: null,
      value: DatabaseService(uid: user!.uid).user_data,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            title: Text("ContestAPP | Home"),
            elevation: 0.0,
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: kLightPink,
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Sign Out",
                    ),
                  ],
                ),
              )
            ],
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xDD613896), width: 2.0),
                insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 70.0),
              ),
              labelColor: Colors.purple,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.bookmark,
                  ),
                  text: "Bookmarked Website",
                ),
                Tab(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  text: "Saved Contests",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ViewContest(),
              SavedContest(),
            ],
          ),
          drawer: DrawerNavigation(),
        ),
      ),
    );
  }
}
