import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/website_screen/website_screen.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SiteListCard extends StatelessWidget {
  final int index;
  final UserSnapshotData? user;
  const SiteListCard({
    Key? key,
    required this.sitesList,
    required this.index,
    required this.user,
  }) : super(key: key);

  final List sitesList;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPrimary,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Text(
                  sitesList[index][0],
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    letterSpacing: 2,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.link_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => WebsiteScreen(
                                  siteListData: sitesList[index],
                                  user: user,
                                ))));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            // Text(sitesList[index][2]),
          ],
        ),
      ),
    );
  }
}
