import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/camera/camera_bloc.dart';
import 'package:flutterapp/ui/extension/widget_extension.dart';

class CameraContent extends StatefulWidget {
  @override
  _CameraContentState createState() => _CameraContentState();
}

class _CameraContentState extends State<CameraContent> {
  CameraBloc _cameraBloc;

  @override
  void initState() {
    _cameraBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  void dispose() {
    _cameraBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CameraBloc, CameraState>(
      listener: (context, state) {
        if (state is CameraInitErrorState) {
          Scaffold.of(context).showSnackBar(SnackBar(
            key: ValueKey('camera_snackbar'),
            content: Text(
              state.error.toString(),
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            action: SnackBarAction(
              textColor: Colors.red,
              label: 'Retry',
              onPressed: () => _cameraBloc.add(CameraInitStartedEvent()),
            ),
            duration: Duration(days: 1),
          ));
        }
      },
      child: _buildStateView(),
    );
  }

  Widget _buildStateView() {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraReadyState) {
          return Stack(
            children: [
              _buildCameraPreviewWidget(state.controller),
              _buildBottomControlWidget(state.controller),
            ],
          );
        }
        return _buildLoadingProgress();
      },
    );
  }

  Widget _buildLoadingProgress() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          strokeWidth: 8.0,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF52575C)),
        ),
      ),
    );
  }

  Widget _buildCameraPreviewWidget(CameraController controller) {
    return Container(
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }

  Widget _buildBottomControlWidget(CameraController controller) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        color: Colors.black45.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _thumbnailWidget(),
              _captureControlRowWidget(controller),
              _cameraTogglesRowWidget(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _captureControlRowWidget(CameraController controller) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.05,
                backgroundColor: Colors.white,
                child: FlatButton(
                  child: Icon(
                    Icons.camera_alt,
                    size: MediaQuery.of(context).size.height * 0.05,
                    color: Colors.grey,
                  ),
                  onPressed: () => _cameraBloc
                      .add(CameraCapturingEvent(controller: controller)),
                )),
          ],
        ),
      ),
    );
  }

  Widget _cameraTogglesRowWidget(CameraController controller) {
    return BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
      return Expanded(
        child: Align(
          alignment: Alignment.center,
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: CircleAvatar(
                  radius: (MediaQuery
                      .of(context)
                      .size
                      .height * 0.05) - 10.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.autorenew,
                    color: Colors.white,
                    size: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05,
                  ),
                ),
                onTap: () =>
                    _cameraBloc
                        .add(
                        CameraChangeDirectionEvent(controller: controller)),
              ),
            ),
          ),
        ),
      );
    });
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
                      radius:
                      (MediaQuery
                          .of(context)
                          .size
                          .height * 0.05) - 10.0,
                      backgroundColor: Colors.black,
                      child: (state is CameraReadyState)
                          ? state.path == null
                          ? Container()
                          : Image.file(
                        state.path,
                        fit: BoxFit.fill,
                      )
                          : Container()),
                  onTap: () => _showBottomSheetImages(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetImages() async {
    await _cameraBloc.getFilesInDirectory().then((data) {
      if (data.isEmpty) return;
      showBottomSheet(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 8.0,
          context: context,
          builder: (ctx) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                      height: 4.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          return _buildImageStack(data[index]);
                        }),
                  ],
                ),
              ),
            );
          });
    });
  }

  Widget _buildImageStack(FileSystemEntity modal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Card(
            color: Colors.red,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.file(
              modal,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            modal.path
                .split('/')
                .last,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'RobotoBold'),
          ),
        ),
        buildSpacer(10.0),
      ],
    );
  }
}
