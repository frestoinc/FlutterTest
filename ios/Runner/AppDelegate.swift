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
    nativeChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch (call.method) {
        case "locationSwitch":
            let bundleId = Bundle.main.bundleIdentifier
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(String(describing: bundleId))")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                print("ios not supported")
            }
            result(bundleId)
            break;
        default:
            result(FlutterMethodNotImplemented)
            break;
        }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}