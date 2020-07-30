import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController  = window?.rootViewController as! FlutterViewController
    let nativeChannel = FlutterMethodChannel(
      name: "flutterapp/custom",
      binaryMessenger: controller.binaryMessenger)

    weak var weakSelf = self
    nativeChannel.methodCallHandler = { call, result in
     if ("bluetoothSwitch" == call?.method) {
       let strNative = weakSelf?.helloFromNativeCode()
       result(strNative)
     } else {
       result(FlutterMethodNotImplemented)
     }
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
