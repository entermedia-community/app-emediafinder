import UIKit
import Flutter
import FirebaseCore
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    [FlutterDownloaderPlugin setPluginRegistrantCallback:registerPlugins];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

void registerPlugins(NSObject<FlutterPluginRegistry>* registry) {
  // [GeneratedPluginRegistrant registerWithRegistry:registry];
    [FlutterDownloaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"vn.hunghd.flutter_downloader"]];
}
