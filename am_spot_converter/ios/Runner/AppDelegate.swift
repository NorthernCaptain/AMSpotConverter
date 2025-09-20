import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let urlLauncherChannel = FlutterMethodChannel(
      name: "am_spot_converter/url_launcher",
      binaryMessenger: controller.binaryMessenger
    )

    urlLauncherChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "shareUrl":
        guard let args = call.arguments as? [String: Any],
              let url = args["url"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "URL is required", details: nil))
          return
        }

        let title = args["title"] as? String ?? "Open with"
        self?.shareUrl(url: url, title: title, result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func shareUrl(url: String, title: String, result: @escaping FlutterResult) {
    guard let urlObj = URL(string: url) else {
      result(false)
      return
    }

    DispatchQueue.main.async {
      guard let rootViewController = self.window?.rootViewController else {
        result(false)
        return
      }

      // Try to open URL directly first
      if UIApplication.shared.canOpenURL(urlObj) {
        UIApplication.shared.open(urlObj, options: [:]) { success in
          result(success)
        }
      } else {
        // Fallback to share sheet
        let activityViewController = UIActivityViewController(
          activityItems: [urlObj],
          applicationActivities: nil
        )

        // For iPad
        if let popover = activityViewController.popoverPresentationController {
          popover.sourceView = rootViewController.view
          popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
          popover.permittedArrowDirections = []
        }

        rootViewController.present(activityViewController, animated: true) {
          result(true)
        }
      }
    }
  }
}
