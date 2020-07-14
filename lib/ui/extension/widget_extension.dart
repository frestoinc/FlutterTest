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
