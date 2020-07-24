import 'package:flutter/material.dart';
import 'package:flutterapp/ui/camera/camera_content.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBackground(),
      child: CameraContent(),
    );
  }
}
