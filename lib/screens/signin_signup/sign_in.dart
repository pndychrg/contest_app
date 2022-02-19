import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //form Global Key
  final _formKey = GlobalKey<FormState>();

  //setting up form variables
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign in to Contests App",
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
                "Sign In to Contests App",
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
                          hintText: "example@gmail.com",
                        ),
                        validator: (val) {
                          return val!.isEmpty == true ? "Enter an email" : null;
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
                        decoration:
                            textInputDecoration.copyWith(hintText: "password"),
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
                            primary: kLightPink,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print(email);
                              print(password);
                            } else {
                              print("Not valid");
                            }
                          },
                          child: Text(" Sign In "),
                        ),
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
