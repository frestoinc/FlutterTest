import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

@widget
Widget buildAppBar({String title}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(color: Color(0xFF25282B)),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}

@widget
Widget buildSpacer(double height) {
  return SizedBox(
    height: height,
  );
}

UnderlineInputBorder buildBorder() {
  return UnderlineInputBorder(
    borderSide: new BorderSide(
      color: const Color(0xFF31B057),
    ),
  );
}

extension Navigation on BuildContext {
  void navigate(StatefulWidget route) {
    Navigator.pushReplacement(
        this, MaterialPageRoute(builder: (context) => route));
  }
}
