import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';

//TODO => FIRST IS BLE-INITIAL-STATE WHERE YOU CHECK WHETHER BLUETOOTH IS AVAILABLE OR NOT
//TODO => THEN YOU CHECK WHETHER BLUETOOTH IS ON OR OFF
//TODO => BLUETOOTH ON OUTPUT BLE-ON-STATE
//TODO => BLUETOOTH OFF OUTPUT BLE-OFF-STATE
//TODO => WHEN STATE IS BLE-OFF-STATE SHOW SNACKBAR THAT BLUETOOTH IS OFF. IF ANDROID TURN ON BLUETOOTH ADAPTER ELSE NOTHING
//TODO => WHEN STATE IS BLE-ON-STATE ADD BLE-START-SCANNING-EVENT AND OUTPUT BLE-SCANNING-STATE
//TODO => SCANNING COMPLETE ADD BLE-SCANNING-COMPLETED-EVENT AND OUTPUT BLE-SCANNING-COMPLETED-STATE
//TODO => FOR NOW OUTPUT THE LIST TO UI
class BleBloc extends Bloc<BleEvent, BleState> {
  FlutterBlue flutterBlue;
  final _location = Location();

  static const _channel = MethodChannel('flutterapp/custom');

  BleBloc() : super(BleInitialState());

  @override
  Stream<BleState> mapEventToState(BleEvent event) async* {
    if (event is BleCheckStateEvent) {
      flutterBlue ??= FlutterBlue.instance;
      await flutterBlue.isAvailable.then((isAvailable) {
        if (!isAvailable) {
          add(BleStatusErrorEvent(
              error:
                  'Bluetooth not available on device. Returning to previous screen.'));
        } else {
          flutterBlue.state.listen((event) {
            _listenToBluetoothState(event);
          });
        }
      }).catchError((e) {
        add(BleStatusErrorEvent(error: e.toString()));
      });
    }

    if (event is BleStatusErrorEvent) {
      yield BleErrorState(error: event.error);
    }

    if (event is BleStatusOffEvent) {
      yield BleStatusOffState();
    }

    if (event is BleTurningOnEvent) {
      if (Platform.isAndroid) {
        await _channel.invokeMethod('bluetoothSwitch').catchError((e) {
          add(BleStatusErrorEvent(error: e.toString()));
        });
      }
    }

    if (event is BleStatusOnEvent) {
      add(BlePreScanningEvent());
    }

    if (event is BlePreScanningEvent) {
      yield (BleScanningState());
      checkLocationPermission();
    }

    if (event is BleStartScanningEvent) {
      try {
        var devicesList = <BluetoothDevice>[];
        await flutterBlue.setLogLevel(LogLevel.debug);
        await flutterBlue.startScan(timeout: Duration(seconds: 5));
        await flutterBlue.scanResults.listen((event) {
          for (var sr in event) {
            print('Device: ${sr.device.name}');
            devicesList.add(sr.device);
          }
        }).onDone(() {
          flutterBlue.stopScan();
        });
        yield BleScanningCompletedState(list: devicesList);
      } on PlatformException {
        yield BleErrorState(
            error: 'Permission Denied. Returning to previous screen');
      } catch (e) {
        yield BleErrorState(error: e.toString());
      }
    }
  }

  void checkLocationPermission() async {
    //TODO IF ANDROID EARLIER THAN 10 RETURN
    var _locationPermissionGranted = await _location.hasPermission();
    if (_locationPermissionGranted == PermissionStatus.granted) {
      checkLocationService();
    } else {
      await _location
          .requestPermission()
          .then((value) => add(value == PermissionStatus.granted
              ? BlePreScanningEvent()
              : BleStatusErrorEvent(
                  error:
                      'Location Permission Denied. Returning to previous screen.')))
          .catchError((e) {
        add(BleStatusErrorEvent(error: e.toString()));
      });
    }
  }

  void checkLocationService() async {
    var _locationServiceEnabled = await _location.serviceEnabled();
    if (_locationServiceEnabled) {
      add(BleStartScanningEvent());
    } else {
      await _channel.invokeMethod('locationSwitch').then((value) {
        add(value == 1
            ? BlePreScanningEvent()
            : BleStatusErrorEvent(
                error:
                    'Location Service not enabled. Returning to previous screen.'));
      }).catchError((e) {
        add(BleStatusErrorEvent(error: e.toString()));
      });
    }
  }

  void _listenToBluetoothState(BluetoothState state) {
    switch (state) {
      case BluetoothState.on:
        add(BleStatusOnEvent());
        break;
      case BluetoothState.off:
      case BluetoothState.turningOff:
        add(BleStatusOffEvent());
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

class BleStatusErrorEvent extends BleEvent {
  final String error;

  const BleStatusErrorEvent({@required this.error});

  @override
  List<Object> get props => [error];
}

class BleStatusOffEvent extends BleEvent {}

class BleTurningOnEvent extends BleEvent {}

class BleStatusOnEvent extends BleEvent {}

class BlePreScanningEvent extends BleEvent {}

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

class BleErrorState extends BleState {
  final String error;

  const BleErrorState({@required this.error});

  @override
  List<Object> get props => [error];
}
