import 'package:flutter/material.dart';
import 'package:flutterapp/ui/home/home_ui.dart';

import 'di/inject.dart';

Future<void> main() async {
  setInjection();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: /*SplashPage()*/ HomePage(), //todo
    );
  }
}
