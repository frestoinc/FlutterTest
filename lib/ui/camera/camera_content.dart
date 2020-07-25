import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/camera/camera_bloc.dart';

class CameraContent extends StatefulWidget {
  @override
  _CameraContentState createState() => _CameraContentState();
}

class _CameraContentState extends State<CameraContent> {
  CameraBloc _cameraBloc;
  CameraLensDirection _direction;

  void _toggle() {
    setState(() {
      _direction = _direction == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
    });
  }

  @override
  void initState() {
    _cameraBloc = BlocProvider.of(context);
    _direction = CameraLensDirection.back;
    super.initState();
  }

  @override
  void dispose() {
    _cameraBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: _cameraPreviewWidget(),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size(),
              color: Colors.black45.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _thumbnailWidget(),
                    _captureControlRowWidget(),
                    _cameraTogglesRowWidget(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  double size() {
    return MediaQuery.of(context).size.height * 0.2;
  }

  Widget _cameraPreviewWidget() {
    return const Text(
      'Loading',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _thumbnailWidget() {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        return Expanded(
          child: Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: Material(
                color: Colors.black,
                child: InkWell(
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                      child: (state is CameraCapturedState)
                          ? Image.asset(state.path)
                          : Container()),
                  onTap: () {},
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _captureControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: FlatButton(
                  child: const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                )),
          ],
        ),
      ),
    );
  }

  Widget _cameraTogglesRowWidget() {
    return BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
      return Expanded(
        child: Align(
          alignment: Alignment.center,
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.autorenew,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                onTap: () {
                  _toggle();
                  _cameraBloc
                      .add(CameraChangeDirectionEvent(direction: _direction));
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
