import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/data/repository/local/directory/directory.dart';
import 'package:flutterapp/di/inject.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitialState());

  int _selectedCamera = 0;
  List<CameraDescription> _cameraList;
  var directory = getIt<PictureDirectory>();

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (event is CameraInitStartedEvent) {
      yield CameraInitStartedState();
      await availableCameras().then((cameras) {
        if (cameras.isNotEmpty) {
          _cameraList = cameras;
          _selectedCamera = 0;
          add(CameraInitSuccessEvent(
              controller: CameraController(
                  cameras[_selectedCamera], ResolutionPreset.high)));
        } else {
          add(CameraInitErrorEvent(error: Exception('No camera found')));
        }
      });
    }

    if (event is CameraInitSuccessEvent) {
      await event.controller
          .initialize()
          .then((value) => add(CameraReadyEvent(controller: event.controller)))
          .catchError((e) => add(CameraInitErrorEvent(error: e)));
    }

    if (event is CameraChangeDirectionEvent) {
      _selectedCamera =
          _selectedCamera < _cameraList.length - 1 ? _selectedCamera + 1 : 0;
      await event.controller.dispose().then((_) => add(CameraInitSuccessEvent(
          controller: CameraController(
              _cameraList[_selectedCamera], ResolutionPreset.high))));
    }

    if (event is CameraCapturingEvent) {
      await directory
          .generateFilename()
          .then((filename) =>
          event.controller
              .takePicture(filename)
              .catchError((e) => add(CameraInitErrorEvent(error: e)))
              .then((value) =>
              add(CameraCapturedEvent(controller: event.controller))))
          .catchError((e) => add(CameraInitErrorEvent(error: e)));
    }

    if (event is CameraCapturedEvent) {
      await directory
          .getLastPictureInDirectory()
          .then((file) =>
          add(CameraReadyToCapturedEvent(
              controller: event.controller, path: file)))
          .catchError((e) => add(CameraInitErrorEvent(error: e)));
    }

    if (event is CameraReadyToCapturedEvent) {
      yield CameraReadyState(controller: event.controller, path: event.path);
    }

    if ((event is CameraReadyEvent)) {
      event.controller.addListener(() {
        if (event.controller.value.hasError) {
          add(CameraErrorEvent(error: event.controller.value.errorDescription));
        }
      });
      add(CameraCapturedEvent(controller: event.controller));
    }

    if (event is CameraInitErrorEvent) {
      yield CameraInitErrorState(error: event.error);
    }

    if ((event is CameraErrorEvent)) {
      yield CameraErrorState(error: event.error);
    }
  }
}

///Event
abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraInitStartedEvent extends CameraEvent {}

class CameraInitErrorEvent extends CameraEvent {
  final error;

  const CameraInitErrorEvent({@required this.error});

  @override
  List<Object> get props => [error];
}

class CameraInitSuccessEvent extends CameraEvent {
  final CameraController controller;

  const CameraInitSuccessEvent({@required this.controller});

  @override
  List<Object> get props => [controller];
}

class CameraReadyToCapturedEvent extends CameraEvent {
  final CameraController controller;
  final File path;

  const CameraReadyToCapturedEvent(
      {@required this.controller, @required this.path});

  @override
  List<Object> get props => [controller, path];
}

class CameraReadyEvent extends CameraEvent {
  final CameraController controller;

  const CameraReadyEvent({@required this.controller});

  @override
  List<Object> get props => [controller];
}

class CameraErrorEvent extends CameraEvent {
  final String error;

  const CameraErrorEvent({@required this.error});

  @override
  List<Object> get props => [error];
}

class CameraChangeDirectionEvent extends CameraEvent {
  final CameraController controller;

  const CameraChangeDirectionEvent({@required this.controller});

  @override
  List<Object> get props => [controller];
}

class CameraCapturingEvent extends CameraEvent {
  final CameraController controller;

  const CameraCapturingEvent({@required this.controller});

  @override
  List<Object> get props => [controller];
}

class CameraCapturedEvent extends CameraEvent {
  final CameraController controller;

  const CameraCapturedEvent({@required this.controller});

  @override
  List<Object> get props => [controller];
}

///State
abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class CameraInitialState extends CameraState {
  @override
  List<Object> get props => [];
}

class CameraInitStartedState extends CameraState {}

class CameraInitErrorState extends CameraState {
  final error;

  const CameraInitErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}

class CameraReadyState extends CameraState {
  final CameraController controller;
  final File path;

  const CameraReadyState({@required this.controller, @required this.path});

  @override
  List<Object> get props => [controller, path];
}

class CameraErrorState extends CameraState {
  final String error;

  const CameraErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}
