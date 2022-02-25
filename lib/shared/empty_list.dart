import 'package:flutter/material.dart';

class EmptyListShow extends StatelessWidget {
  const EmptyListShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/empty.png"),
            SizedBox(
              height: 10,
            ),
            Text(
              "OOps,\nLooks like It's Empty.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
