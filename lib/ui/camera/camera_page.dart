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
      child: BlocProvider(
        create: (context) {
          return CameraBloc();
        },
        child: CameraContent(),
      ),
    );
  }
}
