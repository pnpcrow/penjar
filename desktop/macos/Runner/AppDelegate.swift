import Cocoa
import FlutterMacOS

final class DesktopLaunchRouteBridge {
  static let shared = DesktopLaunchRouteBridge()
  private var pendingRoute: String?
  private var channel: FlutterMethodChannel?

  private init() {}

  func configure(binaryMessenger: FlutterBinaryMessenger) {
    let methodChannel = FlutterMethodChannel(
      name: "penjar/desktop/launch_route",
      binaryMessenger: binaryMessenger
    )
    methodChannel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(nil)
        return
      }
      switch call.method {
      case "consumeLaunchRoute":
        result(self.consumePendingRoute())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    channel = methodChannel
  }

  func handleIncoming(url: URL) {
    let route = url.absoluteString
    pendingRoute = route
    channel?.invokeMethod("onLaunchRoute", arguments: route)
  }

  private func consumePendingRoute() -> String? {
    defer { pendingRoute = nil }
    return pendingRoute
  }
}

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func application(_ application: NSApplication, open urls: [URL]) {
    if let launchUrl = urls.first {
      DesktopLaunchRouteBridge.shared.handleIncoming(url: launchUrl)
    }
    super.application(application, open: urls)
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
