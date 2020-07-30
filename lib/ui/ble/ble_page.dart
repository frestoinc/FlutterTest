import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/ble/ble_bloc.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

import 'ble_content.dart';

class BlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBackground(),
      child: Scaffold(
        appBar: buildAppBar('BLE TEST'),
        body: BlocProvider(
          create: (context) {
            return BleBloc()..add(BleCheckStateEvent());
          },
          child: BleContent(),
        ),
      ),
    );
  }
}
