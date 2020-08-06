import 'dart:async';

import 'package:flutter/material.dart';

class TabBloc {
  final textController = TextEditingController();

  StreamController _controller;

  Stream<Response<String>> get controllerStream => _controller.stream;

  StreamSink<Response<String>> get controllerSink => _controller.sink;

  TabBloc() {
    _controller = StreamController<Response<String>>.broadcast();
  }

  void onButtonPressed() async {
    await Future.delayed(Duration(seconds: 1), () {
      controllerSink.add(Response.loading());
    });

    await Future.delayed(Duration(seconds: 3), () {
      controllerSink.add(Response.success(textController.value.text));
    });

    await Future.delayed(Duration(seconds: 6), () {
      controllerSink.add(Response.error('Exception occured at line 1'));
    });
  }
}

class Response<T> {
  Status status;
  T data;
  String message;

  Response.loading([this.message]) : status = Status.LOADING;

  Response.success(this.data) : status = Status.SUCCESS;

  Response.error(this.message) : status = Status.ERROR;
}

enum Status { LOADING, SUCCESS, ERROR }
