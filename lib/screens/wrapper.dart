import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/home/home.dart';
import 'package:contest_app/screens/startup_screen/startup.dart';
import 'package:contest_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  final Stream<UserData?> user;
  const Wrapper({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //importing user from Stream Using Provider
    final user = Provider.of<UserData?>(context);
    //returning either home or authenticate widget
    if (user == null) {
      return StartUP();
    } else {
      return Home();
    }
  }
}
