import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterapp/di/inject.dart';
import 'package:flutterapp/extension/location_helper.dart';

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
  final _locationHelper = getIt<LocationHelper>();

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
      }).catchError((e) => add(BleStatusErrorEvent(error: e.toString())));
    }

    if (event is BleStatusErrorEvent) {
      yield BleErrorState(error: event.error);
    }

    if (event is BleStatusOffEvent) {
      yield BleStatusOffState();
    }

    if (event is BleTurningOnEvent) {
      if (Platform.isAndroid) {
        await _channel
            .invokeMethod('bluetoothSwitch')
            .catchError((e) => add(BleStatusErrorEvent(error: e.toString())));
      }
    }

    if (event is BleStatusOnEvent) {
      add(BlePreScanningEvent());
    }

    if (event is BlePreScanningEvent) {
      yield (BleScanningState());
      checkLocationPermission();
    }

    //todo refactor
    if (event is BleStartScanningEvent) {
      var devicesList = <BluetoothDevice>[];

      await flutterBlue.setLogLevel(LogLevel.debug);
      await flutterBlue
          .startScan(timeout: Duration(seconds: 5), allowDuplicates: false)
          .catchError((e) => add(BleStatusErrorEvent(error: e.toString())))
          .whenComplete(() {
        flutterBlue.stopScan();
        add(BleScanningCompleteEvent(list: devicesList));
      });
      await flutterBlue.scanResults.listen((event) {
        for (var sr in event) {
          print('Device: ${sr.device.name}');
          devicesList.add(sr.device);
        }
      });
    }

    if (event is BleScanningCompleteEvent) {
      yield BleScanningCompletedState(list: event.list);
    }
  }

  void checkLocationPermission() async {
    await _locationHelper.isLocationPermissionGranted().then((granted) {
      if (granted) {
        checkLocationService();
      } else {
        _locationHelper.requestLocationPermission().then((isGranted) {
          if (isGranted) {
            checkLocationPermission();
          } else {
            print(
                'user still deny the permission. up to you to do smt about it');
          }
        });
      }
    });
  }

  void checkLocationService() async {
    await _locationHelper.isLocationEnabled().then((enabled) {
      if (enabled) {
        print('all ok and ready to proceed');
      } else {
        _locationHelper.enableLocationService().then((isEnabled) {
          if (isEnabled) {
            checkLocationService();
          } else {
            print('user did not turn on location');
          }
        });
      }
    });
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

class BleScanningCompleteEvent extends BleEvent {
  final List<BluetoothDevice> list;

  const BleScanningCompleteEvent({@required this.list});

  @override
  List<Object> get props => [list];
}

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
