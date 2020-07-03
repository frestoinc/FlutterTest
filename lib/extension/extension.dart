import 'dart:async';

import 'package:flutter/material.dart';

void navigateTo(BuildContext context, int duration, StatefulWidget route) {
  Timer(
      Duration(seconds: duration),
      () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext ctx) => route)));
}
