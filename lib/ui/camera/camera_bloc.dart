import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitial());

  CameraController _controller;
  CameraLensDirection _direction;

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if ((event is CameraInitialisationErrorEvent)) {
      yield CameraInitialisationErrorState(error: event.error);
    }

    if ((event is CameraInitialisationSuccessEvent)) {
      if (_controller != null) {
        await _controller.dispose();
      }

      _controller = event.controller;
      try {
        await _controller.initialize();
        add(CameraReadyEvent());
      } on CameraException catch (e) {
        yield CameraInitialisationErrorState(error: e);
      }
    }

    if (event is CameraChangeDirectionEvent) {
      yield CameraChangeDirectionState(direction: _direction);
    }

    if ((event is CameraReadyEvent)) {
      _controller.addListener(() {
        if (_controller.value.hasError) {
          add(CameraErrorEvent(error: _controller.value.errorDescription));
        }
      });
    }

    if ((event is CameraErrorEvent)) {
      yield CameraErrorState(error: event.error);
    }
  }

  void toggle() {
    _direction = _direction == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    add(CameraChangeDirectionEvent());
  }

  void initialise() {
    availableCameras().then((cameras) {
      _direction = cameras[0].lensDirection;
      add(cameras.isNotEmpty
          ? CameraInitialisationSuccessEvent(
              controller: CameraController(cameras[0], ResolutionPreset.high))
          : CameraInitialisationErrorEvent(
              error: Exception('No camera found')));
    });
  }
}

///Event
abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraInitialisationErrorEvent extends CameraEvent {
  final error;

  const CameraInitialisationErrorEvent({@required this.error});

  @override
  List<Object> get props => [error];
}

class CameraInitialisationSuccessEvent extends CameraEvent {
  final CameraController controller;

  const CameraInitialisationSuccessEvent({@required this.controller});

  @override
  List<Object> get props => [controller];
}

class CameraReadyEvent extends CameraEvent {}

class CameraErrorEvent extends CameraEvent {
  final String error;

  const CameraErrorEvent({@required this.error});

  @override
  List<Object> get props => [error];
}

class CameraChangeDirectionEvent extends CameraEvent {}

class CameraCapturedEvent extends CameraEvent {
  final String path;

  const CameraCapturedEvent({@required this.path});

  @override
  List<Object> get props => [path];
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

class CameraInitialisationErrorState extends CameraState {
  final error;

  const CameraInitialisationErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}

class CameraAvailableState extends CameraState {
  final CameraController controller;

  const CameraAvailableState({@required this.controller});

  @override
  List<Object> get props => [controller];
}

class CameraChangeDirectionState extends CameraState {
  final CameraLensDirection direction;

  const CameraChangeDirectionState({@required this.direction});

  @override
  List<Object> get props => [direction];
}

class CameraCapturedState extends CameraState {
  final String path;

  const CameraCapturedState({@required this.path});

  @override
  List<Object> get props => [path];
}

class CameraErrorState extends CameraState {
  final String error;

  const CameraErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}
