import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

let BASE_URL = "https://api-preprod-sandbox.mirrorfly.com/api/v1/"
let LICENSE_KEY = "6JJucJz7VyrVjxOVa1qJeycvm6cNmP"
let CONTAINER_ID = "group.com.mirrorfly.qa"

override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
  ...

  FlyBaseController().initSDK(controller: controller, licenseKey: LICENSE_KEY, isTrial: !IS_LIVE, baseUrl: BASE_URL, containerID: CONTAINER_ID)
  
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}


override func applicationDidBecomeActive(_ application: UIApplication) {
  FlyBaseController().applicationDidBecomeActive()     
}

override func applicationDidEnterBackground(_ application: UIApplication) {
  FlyBaseController().applicationDidEnterBackground()    
}

FlyChat.registerUser(username, FCM_TOCKEN).then((value) {
    if (value.contains("data")) {
      var userData = registerModelFromJson(value);
    // Get Username and password from the object
    }
}).catchError((error) {
    // Register user failed print throwable to find the exception details.
    debugPrint(error.message);
});

