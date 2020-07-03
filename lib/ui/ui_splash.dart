import 'package:flutter/material.dart';
import 'package:flutterapp/extension/extension.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

import 'extension/widget_extension.dart';
import 'login/ui_login.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    navigateTo(context, 2, new LoginPage());
    return Container(
      decoration: const BoxDecoration(
        image: const DecorationImage(
          image: const AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          appBar: buildAppBar(title: "Splash Page"),
          backgroundColor: Colors.transparent,
          body: _buildSplashText(message: "Flutter App Demo")),
    );
  }
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
