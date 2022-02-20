import 'dart:convert';

import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WebsiteScreen extends StatefulWidget {
  final siteListData;
  const WebsiteScreen({Key? key, required this.siteListData}) : super(key: key);

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
            onPressed: () {
              setState(() {
                _bookmarkButton = !_bookmarkButton;
              });
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
