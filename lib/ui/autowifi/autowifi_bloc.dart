import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/data/wifi/scan_result.dart';

//TODO CHECK WHETHER WIFI STATE IS ON OR OFF
//TODO WIFI ON OUTPUT WIFI-ON-STATE
//TODO WIFI OFF OUTPUT WIFI-OFF-STATE
//TODO WHEN STATE IS WIFI-OFF-STATE
//TODO WHEN STATE IS WIFI-ON-STATE SCAN, DISPLAY LIST, TAP ON ONE, SHOW PASSWORD DIALOG TRY TO CONNECT

class AutoWifiBloc extends Bloc<AutoWifiEvent, AutoWifiState> {
  AutoWifiBloc() : super(AutoWifiInitialState());

  static const _channel = MethodChannel('flutterapp/custom');

  @override
  Stream<AutoWifiState> mapEventToState(AutoWifiEvent event) async* {
    if (event is AutoWifiCheckStateEvent) {
      if (Platform.isAndroid) {
        add(AutoWifiStartScanningEvent());
      }
    }

    if (event is AutoWifiStartScanningEvent) {
      await _channel.invokeMethod<String>('autoWifiScan').then((value) {
        final list = (jsonDecode(value) as List)
            .map((e) => ScanResult.fromJson(e))
            .toList();
        add(AutoWifiScanningCompleteEvent(list: list));
      }).catchError((e) => add(AutoWifiErrorEvent(error: e.toString())));
    }

    if (event is AutoWifiErrorEvent) {
      yield AutoWifiErrorState(error: event.error);
    }

    if (event is AutoWifiScanningCompleteEvent) {
      yield AutoWifiScanCompleteState(list: event.list);
    }

    if (event is AutoWifiAttemptConnectEvent) {
      yield AutoWifiAttemptConnectState();
      var value = {'SSID': event.scanResult.SSID, 'pwd': event.pwd};
      await _channel.invokeMethod<bool>('autoWifiConnect', value).then((value) {
        print('status return: $value');
        add(value
            ? AutoWifiSuccessEvent()
            : AutoWifiErrorEvent(error: 'Not able to connect'));
      }).catchError((e) => add(AutoWifiErrorEvent(error: e.toString())));
    }

    if (event is AutoWifiSuccessEvent) {
      yield AutoWifiSuccessState();
    }
  }
}

abstract class AutoWifiEvent extends Equatable {
  const AutoWifiEvent();

  @override
  List<Object> get props => [];
}

class AutoWifiCheckStateEvent extends AutoWifiEvent {}

class AutoWifiStartScanningEvent extends AutoWifiEvent {}

class AutoWifiErrorEvent extends AutoWifiEvent {
  final String error;

  const AutoWifiErrorEvent({@required this.error});

  @override
  List<Object> get props => [error];
}

class AutoWifiScanningCompleteEvent extends AutoWifiEvent {
  final List<ScanResult> list;

  const AutoWifiScanningCompleteEvent({@required this.list});

  @override
  List<Object> get props => [list];
}

class AutoWifiAttemptConnectEvent extends AutoWifiEvent {
  final ScanResult scanResult;
  final String pwd;

  const AutoWifiAttemptConnectEvent(
      {@required this.scanResult, @required this.pwd});

  @override
  List<Object> get props => [scanResult, pwd];
}

class AutoWifiSuccessEvent extends AutoWifiEvent {}

abstract class AutoWifiState extends Equatable {
  const AutoWifiState();

  @override
  List<Object> get props => [];
}

class AutoWifiInitialState extends AutoWifiState {}

class AutoWifiErrorState extends AutoWifiState {
  final String error;

  const AutoWifiErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}

class AutoWifiScanCompleteState extends AutoWifiState {
  final List<ScanResult> list;

  const AutoWifiScanCompleteState({@required this.list});

  @override
  List<Object> get props => [list];
}

class AutoWifiAttemptConnectState extends AutoWifiState {}

class AutoWifiSuccessState extends AutoWifiState {}
