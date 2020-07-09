import 'package:flutter/material.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

import 'extension/widget_extension.dart';
import 'login/login_ui.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

AnimationController _controller;
bool _loaded = false;

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: const DecorationImage(
          image: const AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: buildAppBar(title: SPLASH_TITLE),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSplashText(message: SPLASH_BODY),
            _buildAnimation(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addStatusListener((status) {
        setState(() {});
        if (status == AnimationStatus.completed) {
          toggleState();
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(milliseconds: 500), () async {
            toggleState();
          });
        }
      });
    _controller.forward();
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void toggleState() {
  _loaded = !_loaded;
  if (_loaded)
    _controller.reverse();
  else
    _controller.forward();
}

@widget
Widget _buildAnimation() {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    switchInCurve: Curves.easeIn,
    switchOutCurve: Curves.easeOut,
    child: new Image.asset(
      _loaded ? "assets/images/door1.png" : "assets/images/door2.png",
      key: ValueKey<bool>(_loaded),
    ),
  );
}

@widget
Widget _buildSplashText({String message}) {
  return Center(
    child: Text(
      message,
      softWrap: true,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Color(0xFF52575C), fontSize: 40, fontFamily: 'RobotoBold'),
    ),
  );
}
