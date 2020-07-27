import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitial());

  int _selectedCamera = 0;
  List<CameraDescription> _cameraList;

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

    if (event is CameraInitErrorEvent) {
      yield CameraInitErrorState(error: event.error);
    }

    if (event is CameraInitSuccessEvent) {
      try {
        await event.controller.initialize();
        add(CameraReadyEvent(controller: event.controller));
      } on CameraException catch (e) {
        yield CameraInitErrorState(error: e);
      }
    }

    if (event is CameraChangeDirectionEvent) {
      _selectedCamera =
          _selectedCamera < _cameraList.length - 1 ? _selectedCamera + 1 : 0;
      await event.controller.dispose();
      add(CameraInitSuccessEvent(
          controller: CameraController(
              _cameraList[_selectedCamera], ResolutionPreset.high)));
    }

    if (event is CameraCapturingEvent) {
      try {
        var filename = await _generateFilename();
        await event.controller.takePicture(filename).then((value) {
          add(CameraCapturedEvent(controller: event.controller));
        });
      } on CameraException catch (e) {
        yield CameraInitErrorState(error: e);
      }
    }

    if (event is CameraCapturedEvent) {
      try {
        var directory = await _getLastPictureInDirectory();
        yield CameraReadyState(controller: event.controller, path: directory);
      } on Exception catch (e) {
        yield CameraInitErrorState(error: e);
      }
    }

    if ((event is CameraReadyEvent)) {
      event.controller.addListener(() {
        if (event.controller.value.hasError) {
          add(CameraErrorEvent(error: event.controller.value.errorDescription));
        }
      });
      add(CameraCapturedEvent(controller: event.controller));
    }

    if ((event is CameraErrorEvent)) {
      yield CameraErrorState(error: event.error);
    }
  }

  Future<Directory> _getDirectory() async {
    var appDirectory = await getApplicationDocumentsDirectory();
    var pictureDirectory = '${appDirectory.path}/Pictures';
    return await Directory(pictureDirectory).create(recursive: true);
  }

  Future<String> _generateFilename() async {
    var directory = await _getDirectory();
    var currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    return '${directory.path}/${currentTime}.jpg';
  }

  Future<List<FileSystemEntity>> getFilesInDirectory() async {
    var directory = await _getDirectory();
    var files = directory.listSync().toList();
    if (files.isEmpty) {
      return null;
    }
    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  Future<File> _getLastPictureInDirectory() async {
    var files = await getFilesInDirectory();
    if (files == null) return null;
    final mimeType = lookupMimeType('/some/path/to/file/file.jpg');
    var file = files.firstWhere((element) => element.path.endsWith('.jpg'));
    return file ?? null;
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

class CameraInitial extends CameraState {
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
