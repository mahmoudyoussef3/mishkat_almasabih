import Flutter
import UIKit
import FirebaseCore
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }

    GeneratedPluginRegistrant.register(with: self)
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let prayerChannel = FlutterMethodChannel(name: "com.mishkat_almasabih.app/prayer_notifications",
                                              binaryMessenger: controller.binaryMessenger)
    
    prayerChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "schedulePrayerNotifications":
        if let jsonString = call.arguments as? String {
            self.schedulePrayerNotifications(jsonString: jsonString)
            result(true)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected JSON string", details: nil))
        }
      case "cancelPrayerNotifications":
        self.cancelPrayerNotifications()
        result(true)
      case "scheduleTestPrayerNotification":
        if let jsonString = call.arguments as? String {
            self.schedulePrayerNotifications(jsonString: jsonString)
            result(true)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected JSON string", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func schedulePrayerNotifications(jsonString: String) {
      guard let data = jsonString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let items = json["items"] as? [[String: Any]] else {
          return
      }

      let center = UNUserNotificationCenter.current()
      
      for item in items {
          guard let id = item["id"] as? Int,
                let title = item["title"] as? String,
                let body = item["body"] as? String,
                let fireAtMillis = item["fireAtMillis"] as? Int64 else {
              continue
          }
          
          let date = Date(timeIntervalSince1970: TimeInterval(fireAtMillis) / 1000.0)
          
          if date <= Date() { continue }
          
          let content = UNMutableNotificationContent()
          content.title = title
          content.body = body
          content.sound = UNNotificationSound.default
          
          let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
          let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
          
          let request = UNNotificationRequest(identifier: "prayer_notification_\(id)", content: content, trigger: trigger)
          
          center.add(request) { (error) in
              if let error = error {
                  print("Error scheduling notification: \(error)")
              }
          }
      }
  }
  
  private func cancelPrayerNotifications() {
      let center = UNUserNotificationCenter.current()
      center.getPendingNotificationRequests { (requests) in
          let prayerIdentifiers = requests.map { $0.identifier }.filter { $0.hasPrefix("prayer_notification_") }
          center.removePendingNotificationRequests(withIdentifiers: prayerIdentifiers)
      }
  }
}
