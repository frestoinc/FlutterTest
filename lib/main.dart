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
    return MaterialApp(
      title: 'Flutter Demo',
      home: SplashPage(),
    );
  }
}

/*void _testApi() {
  final _manager = getIt.get<DataManager>();
  var data = _manager.getRepositories();
  data.then((value) {
    value.fold(
            (l) => print("exception: $l"),
            (r) => r.forEach((element) {
          print(element);
        }));
  });
}*/
