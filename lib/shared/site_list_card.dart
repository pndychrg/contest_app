import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/website_screen/website_screen.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SiteListCard extends StatelessWidget {
  final UserSnapshotData? user;
  const SiteListCard({
    Key? key,
    required this.sitesListData,
    required this.user,
  }) : super(key: key);

  final List sitesListData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(8),
        // child: Column(
        //   children: <Widget>[
        //     Row(
        //       children: [
        //         Text(
        //           sitesListData[0],
        //           style: GoogleFonts.lato(
        //             fontSize: 24,
        //             letterSpacing: 2,
        //           ),
        //         ),
        //         Spacer(),
        //         IconButton(
        //           icon: Icon(Icons.link_rounded),
        //           onPressed: () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: ((context) => WebsiteScreen(
        //                           siteListData: sitesListData,
        //                           user: user,
        //                         ))));
        //           },
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       height: 7,
        //     ),
        //     // Text(sitesList[index][2]),
        //   ],
        // ),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => WebsiteScreen(
                          siteListData: sitesListData,
                          user: user,
                        ))));
          },
          horizontalTitleGap: 0,
          leading: Icon(
            Icons.circle,
            size: 10,
            color: Colors.white,
          ),
          title: Text(
            sitesListData[0],
            style: GoogleFonts.lato(
              fontSize: 20,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
