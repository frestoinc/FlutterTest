import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class LocationHelper {
  Future<bool> isLocationEnabled();

  Future<bool> isLocationPermissionGranted();

  Future<bool> enableLocationService();

  Future<bool> requestLocationPermission();
}

class LocationHelperImpl implements LocationHelper {
  const LocationHelperImpl();

  @override
  Future<bool> isLocationEnabled() async {
    var result1 = await Permission.locationAlways.serviceStatus;
    var result2 = await Permission.locationWhenInUse.serviceStatus;

    if (result1 == ServiceStatus.enabled || result2 == ServiceStatus.enabled) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> isLocationPermissionGranted() async {
    var result = await Permission.location.status;
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> enableLocationService() async {
    return await MethodChannel('flutterapp/custom')
        .invokeMethod<bool>('locationSwitch');
  }

  @override
  Future<bool> requestLocationPermission() async {
    final _result = await Permission.location.request();
    if (_result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
}
