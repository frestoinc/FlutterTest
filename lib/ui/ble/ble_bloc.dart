import 'dart:io' show Platform;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutterapp/di/inject.dart';
import 'package:flutterapp/extension/location_helper.dart';

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

    if (event is BleStartScanningEvent) {
      var devicesList = <ScanResult>[];
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
          devicesList.add(sr);
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
          add(isGranted
              ? BlePreScanningEvent()
              : BleStatusErrorEvent(
                  error:
                      'Location Permission Denied. Returning to previous screen.'));
        });
      }
    });
  }

  void checkLocationService() async {
    await _locationHelper.isLocationEnabled().then((enabled) {
      if (enabled) {
        add((BleStartScanningEvent()));
      } else {
        _locationHelper.enableLocationService().then((isEnabled) {
          add(isEnabled
              ? BlePreScanningEvent()
              : BleStatusErrorEvent(
                  error:
                      'Location Service not enabled. Returning to previous screen.'));
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

  Future<void> rescan() async {
    if (state is! BleScanningState) {
      add(BlePreScanningEvent());
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
  final List<ScanResult> list;

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
  final List<ScanResult> list;

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
