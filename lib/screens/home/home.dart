import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/home/saved_contest.dart';
import 'package:contest_app/screens/home/website_bookmark.dart';
import 'package:contest_app/services/auth.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:contest_app/shared/drawer_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //instance of authentication service
  final AuthService _auth = AuthService();
  List contestSites = [];
  Future<void> _getSitesList() async {
    var url = "https://kontests.net/api/v1/sites";
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      contestSites = data;
    });
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
          drawer: DrawerNavigation(),
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            title: Text("ContestAPP | Home"),
            elevation: 0.0,
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  // primary: kpurple,
                  primary: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? kpurple
                      : kpurple.withOpacity(0.5),
                  side: BorderSide.none,
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app, color: Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFFF76F02), width: 2.0),
                insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 70.0),
              ),
              labelColor: Colors.greenAccent,
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
          body: HomeTabView(user: user),
        ),
      ),
    );
  }
}

class HomeTabView extends StatelessWidget {
  const HomeTabView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserData? user;

  @override
  Widget build(BuildContext context) {
    UserSnapshotData? userSnapshotData =
        Provider.of<UserSnapshotData?>(context);
    return TabBarView(
      children: <Widget>[
        WebsiteBookmark(
          uid: userSnapshotData?.uid,
        ),
        SavedContest(
          uid: userSnapshotData?.uid,
        ),
      ],
    );
  }
}
