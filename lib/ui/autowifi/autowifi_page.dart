import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

import 'autowifi_bloc.dart';
import 'autowifi_content.dart';

class AutoWifiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBackground(),
      child: Scaffold(
        appBar: buildAppBar('AutoWifi TEST'),
        body: BlocProvider(
          create: (context) {
            return AutoWifiBloc()..add(AutoWifiCheckStateEvent());
          },
          child: AutoWifiContent(),
        ),
      ),
    );
  }
}
