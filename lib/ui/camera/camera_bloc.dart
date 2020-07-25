import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitial());

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

///Event
abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraAvailableEvent extends CameraEvent {
  final CameraController controller;

  const CameraAvailableEvent({@required this.controller});

  @override
  List<Object> get props => [controller];
}

class CameraChangeDirectionEvent extends CameraEvent {
  final CameraLensDirection direction;

  const CameraChangeDirectionEvent({@required this.direction});

  @override
  List<Object> get props => [direction];
}

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
