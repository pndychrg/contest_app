import 'package:contest_app/models/user_data.dart';
import 'package:contest_app/screens/startup_screen/startup.dart';
import 'package:contest_app/screens/wrapper.dart';
import 'package:contest_app/services/auth.dart';
import 'package:contest_app/shared/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(
          user: AuthService().user,
        ),
        darkTheme: darkThemeData(context),
        theme: ligthThemeData(context),
      ),
    );
  }
}
