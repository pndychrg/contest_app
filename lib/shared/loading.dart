import 'package:contest_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: SpinKitSpinningLines(
          color: kpurple,
          size: 50.0,
        ),
      ),
    );
  }
}
