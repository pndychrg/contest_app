import 'package:contest_app/main.dart';
import 'package:contest_app/services/auth.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:contest_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Authenticating service
  final AuthService _auth = AuthService();
  //form Global Key
  final _formKey = GlobalKey<FormState>();

  //setting up form variables
  String email = '';
  String password = '';
  String error = '';
  String name = '';

  // boolean for loading widget
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Register In Contests App",
                style: GoogleFonts.lato(),
              ),
            ),
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/20 User interaction.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 300,
                    ),
                    Text(
                      "Sign Up in Contests App",
                      style: GoogleFonts.lato(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Name"),
                              validator: (val) {
                                return val!.isEmpty == true
                                    ? "Enter an email"
                                    : null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                hintText: "example@gmail.com",
                              ),
                              validator: (val) {
                                return val!.isEmpty == true
                                    ? "Enter an email"
                                    : null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: "password"),
                              validator: (val) {
                                return val!.length < 6
                                    ? "Enter password at least 6 chars long"
                                    : null;
                              },
                              obscureText: true,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: kpurple,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result =
                                        await _auth.registerWithEmailPass(
                                            email, password, name);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error = "Please Supply a valid email";
                                      });
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => MyApp()));
                                    }
                                  }
                                },
                                child: Text(" Sign Up "),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
