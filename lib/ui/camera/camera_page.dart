import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/camera/camera_content.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

import 'camera_bloc.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBackground(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocProvider(
          create: (context) {
            return CameraBloc()..add(CameraInitStartedEvent());
          },
          child: CameraContent(),
        ),
      ),
    );
  }
}
