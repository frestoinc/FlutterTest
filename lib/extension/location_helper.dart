import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class LocationHelper {
  Future<bool> isLocationEnabled();

  Future<bool> isLocationPermissionGranted();

  Future<bool> enableLocationService();

  Future<bool> requestLocationPermission();
}

//SAMPLE USAGE
// final _locationHelper = getIt<LocationHelper>();
//
//void checkLocationPermission() async {
//    await _locationHelper.isLocationPermissionGranted().then((granted) {
//      if (granted) {
//        checkLocationService();
//      } else {
//        _locationHelper.requestLocationPermission().then((isGranted) {
//          if (isGranted) {
//            checkLocationPermission();
//          } else {
//            print(
//                'user still deny the permission. up to you to do smt about it');
//          }
//        });
//      }
//    });
//  }
//
//  void checkLocationService() async {
//    await _locationHelper.isLocationEnabled().then((enabled) {
//      if (enabled) {
//        print('all ok and ready to proceed');
//      } else {
//        _locationHelper.enableLocationService().then((isEnabled) {
//          if (isEnabled) {
//            checkLocationService();
//          } else {
//            print('user did not turn on location. up to you to do smt about it');
//          }
//        });
//      }
//    });
//  }
class LocationHelperImpl implements LocationHelper {
  const LocationHelperImpl();

  @override
  Future<bool> isLocationEnabled() async {
    var result1 = await Permission.locationAlways.serviceStatus;
    var result2 = await Permission.locationWhenInUse.serviceStatus;

    return result1 == ServiceStatus.enabled || result2 == ServiceStatus.enabled;
  }

  @override
  Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.status == PermissionStatus.granted;
  }

  @override
  Future<bool> enableLocationService() async {
    return await MethodChannel('flutterapp/custom')
        .invokeMethod<bool>('locationSwitch');
  }

  @override
  Future<bool> requestLocationPermission() async {
    return await Permission.location.request() == PermissionStatus.granted;
  }
}
