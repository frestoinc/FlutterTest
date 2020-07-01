import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/background.png",
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar: splashAppBar,
          body: Center(
            child: splashText,
          ),
        ),
      ],
    );
  }
}

Widget splashText = Text(
  'Flutter Test Demo',
  softWrap: true,
  textAlign: TextAlign.center,
  style: TextStyle(
      color: Color(0xFF52575C), fontSize: 40, fontFamily: 'RobotoBold'),
);

Widget splashAppBar = AppBar(
  title: Text(
    "SplashPage",
    style: TextStyle(color: Color(0xFF25282B)),
  ),
  centerTitle: true,
  backgroundColor: Colors.white,
  elevation: 8.0,
);
