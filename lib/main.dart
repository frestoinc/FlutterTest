import 'package:flutter/material.dart';
import 'package:flutterapp/ui/ui_splash.dart';

import 'di/inject.dart';

void main() {
  setInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: new SplashPage(),
    );
  }
}
