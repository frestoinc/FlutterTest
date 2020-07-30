import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

//TODO => FIRST IS BLE-INITIAL-STATE WHERE YOU CHECK WHETHER BLUETOOTH IS AVAILABLE OR NOT
//TODO => THEN YOU CHECK WHETHER BLUETOOTH IS ON OR OFF
//TODO => BLUETOOTH ON OUTPUT BLE-ON-STATE
//TODO => BLUETOOTH OFF OUTPUT BLE-OFF-STATE
//TODO => WHEN STATE IS BLE-ON-STATE ADD BLE-START-SCANNING-EVENT AND OUTPUT BLE-SCANNING-STATE
//TODO => SCANNING COMPLETE ADD BLE-SCANNING-COMPLETED-EVENT AND OUTPUT BLE-SCANNING-COMPLETED-STATE
//TODO => FOR NOW OUTPUT THE LIST TO UI
class BleBloc extends Bloc<BleEvent, BleState> {
  FlutterBlue flutterBlue;

  BleBloc() : super(BleInitialState());

  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  @override
  Stream<BleState> mapEventToState(BleEvent event) async* {
    if (event is BleCheckStateEvent) {
      try {
        flutterBlue ??= FlutterBlue.instance;
        var bleAvailable = await flutterBlue.isAvailable;
        if (!bleAvailable) {
          add(BleStatusMissingEvent());
        } else {
          flutterBlue.state.listen((event) {
            _listenToBluetoothState(event);
          });

          /*var bleStatus = await flutterBlue.isOn;
          add(bleStatus ? BleStatusOnEvent() : BleStatusOffEvent());*/
        }
      } on Exception catch (e) {
        yield BleErrorState(error: e.toString());
      }
    }

    if (event is BleStatusMissingEvent) {
      yield BleStatusMissingState();
    }

    if (event is BleStatusOffEvent) {
      yield BleStatusOffState();
    }

    if (event is BleTurningOnEvent) {
      if (Platform.isAndroid) {
        try {
          var response = await MethodChannel('flutterapp/custom')
              .invokeMethod('bluetoothSwitch');
          print('response: $response');
        } catch (e) {
          yield BleErrorState(error: e.toString());
        }
      }
    }

    if (event is BleStatusOnEvent) {
      add(BleStartScanningEvent());
      yield (BleScanningState());
    }

    if (event is BleStartScanningEvent) {
      try {
        await flutterBlue.setLogLevel(LogLevel.debug);
        await flutterBlue.startScan(timeout: Duration(seconds: 5));
        await flutterBlue.scanResults.listen((event) {
          for (var sr in event) {
            print('Device: ${sr.device.name}');
            devicesList.add(sr.device);
          }
        });
        await flutterBlue.stopScan();
        yield BleScanningCompletedState(list: devicesList);
      } on PlatformException {
        yield BleErrorState(
            error: 'Permission Denied. Returning to previous screen');
      } catch (e) {
        yield BleErrorState(error: e.toString());
      }
    }
  }

  void _listenToBluetoothState(BluetoothState state) {
    switch (state) {
      case BluetoothState.unavailable:
        add(BleStatusMissingEvent());
        break;

      case BluetoothState.off:
        add(BleStatusOffEvent());
        break;

      case BluetoothState.on:
        add(BleStatusOnEvent());
        break;
      default:
        break;
    }
  }
}

///Event
abstract class BleEvent extends Equatable {
  const BleEvent();

  @override
  List<Object> get props => [];
}

class BleCheckStateEvent extends BleEvent {}

class BleCheckStatusEvent extends BleEvent {}

class BleStatusMissingEvent extends BleEvent {}

class BleStatusOffEvent extends BleEvent {}

class BleTurningOnEvent extends BleEvent {}

class BleStatusOnEvent extends BleEvent {}

class BleStartScanningEvent extends BleEvent {}

abstract class BleState extends Equatable {
  const BleState();

  @override
  List<Object> get props => [];
}

class BleInitialState extends BleState {}

class BleScanningState extends BleState {}

class BleScanningCompletedState extends BleState {
  final List<BluetoothDevice> list;

  const BleScanningCompletedState({@required this.list});

  @override
  List<Object> get props => [list];
}

class BleStatusOffState extends BleState {}

class BleStatusMissingState extends BleState {}

class BleErrorState extends BleState {
  final String error;

  const BleErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}
