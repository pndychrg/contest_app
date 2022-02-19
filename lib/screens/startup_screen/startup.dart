import 'package:contest_app/screens/signin_signup/sign_in.dart';
import 'package:contest_app/screens/signin_signup/sign_up.dart';
import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StartUP extends StatelessWidget {
  StartUP({Key? key}) : super(key: key);

  final carouselText = [
    '',
    "Get Your Contests Info in your Hands",
    "Get Contests Timings Easily",
    "Know If your Contests is in a Day",
    "All of this in One App"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:
      //     MediaQuery.of(context).platformBrightness == Brightness.light
      //         ? kPrimary
      //         : Color.fromARGB(255, 18, 18, 18),
      // appBar: AppBar(
      //   backgroundColor: kLightPink,
      //   title: Center(child: Text("Contest App")),
      // ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            Container(
              width: 350,
              height: 75,
              decoration: BoxDecoration(
                color: kLightPink.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  SvgPicture.asset(
                    "assets/svg/logo.svg",
                    width: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "The Contests App",
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CarouselSlider(
              options: CarouselOptions(height: 470.0),
              items: [1, 2, 3, 4].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                        decoration: BoxDecoration(
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.black,
                          border: Border.all(
                            color: kLightPink,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: kLightBlue,
                              spreadRadius: 4,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              carouselText[i],
                              style: GoogleFonts.lato(fontSize: 30.0),
                            ),
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/${i.toString()}.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ));
                  },
                );
              }).toList(),
            ),
            Text(
              "If You haven't Registered Yet",
              style: GoogleFonts.lato(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  primary: kLightPink,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => SignUp())));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.signInAlt),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign Up",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Already Registered",
              style: GoogleFonts.lato(
                fontSize: 15,
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  primary: kLightPurple,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => SignIn())));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.personBooth),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign In",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
