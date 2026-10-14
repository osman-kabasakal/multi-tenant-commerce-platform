import Flutter
import UIKit
import IOSSecuritySuite

public class FlutterJailbreakDetectionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_jailbreak_detection", binaryMessenger: registrar.messenger())
    let instance = FlutterJailbreakDetectionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "jailbroken":

                let check2 = IOSSecuritySuite.amIJailbroken()
                return result(check2)
                break
            case "developerMode":
            #if DEBUG
                                        result(IOSSecuritySuite.amIRunInEmulator())
                                    #else
                                        let isAppStoreReceipt = Bundle.main.appStoreReceiptURL?.lastPathComponent == "receipt"
                                                        result(IOSSecuritySuite.amIRunInEmulator() && !isAppStoreReceipt)
                                    #endif
                result(IOSSecuritySuite.amIRunInEmulator())
                break
            default:
                result(FlutterMethodNotImplemented)
    }
  }
}
