import Flutter
import UIKit

/// Screenshot and screen recording guard for fintech apps.
/// - Disable screenshots (via blur overlay when backgrounded)
/// - Detect and blur during screen recording
/// - Blur app when in background
public class FlutterScreenshotGuardPlugin: NSObject, FlutterPlugin {

    private var overlayView: UIView?
    private var blurOnBackgroundEnabled = false
    private var screenshotBlockingEnabled = false
    private var blurIntensity: Double = 0.5
    private var screenCaptureObserver: NSObjectProtocol?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_screenshot_guard",
            binaryMessenger: registrar.messenger()
        )
        let instance = FlutterScreenshotGuardPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "enableScreenshotBlocking":
            screenshotBlockingEnabled = true
            setupScreenCaptureDetection()
            result(nil)
        case "disableScreenshotBlocking":
            screenshotBlockingEnabled = false
            removeScreenCaptureDetection()
            hideOverlay()
            result(nil)
        case "enableBlurOnBackground":
            blurOnBackgroundEnabled = true
            setupAppLifecycleObserver()
            result(nil)
        case "disableBlurOnBackground":
            blurOnBackgroundEnabled = false
            hideOverlay()
            removeAppLifecycleObserver()
            result(nil)
        case "enableSecureMode":
            screenshotBlockingEnabled = true
            blurOnBackgroundEnabled = true
            setupScreenCaptureDetection()
            setupAppLifecycleObserver()
            result(nil)
        case "disableSecureMode":
            screenshotBlockingEnabled = false
            blurOnBackgroundEnabled = false
            removeScreenCaptureDetection()
            removeAppLifecycleObserver()
            hideOverlay()
            result(nil)
        case "setBlurIntensity":
            if let args = call.arguments as? [String: Any],
               let intensity = args["intensity"] as? Double {
                blurIntensity = min(max(intensity, 0), 1)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Screen Recording Detection (iOS 11+)

    private func setupScreenCaptureDetection() {
        removeScreenCaptureDetection()
        if #available(iOS 11.0, *) {
            screenCaptureObserver = NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.handleScreenCaptureChanged()
            }
            handleScreenCaptureChanged()
        }
    }

    private func removeScreenCaptureDetection() {
        if let observer = screenCaptureObserver {
            NotificationCenter.default.removeObserver(observer)
            screenCaptureObserver = nil
        }
    }

    @available(iOS 11.0, *)
    private func handleScreenCaptureChanged() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if UIScreen.main.isCaptured {
                if self.screenshotBlockingEnabled || self.blurOnBackgroundEnabled {
                    self.showOverlay()
                }
            } else {
                self.hideOverlay()
            }
        }
    }

    // MARK: - App Lifecycle

    private func setupAppLifecycleObserver() {
        removeAppLifecycleObserver()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    private func removeAppLifecycleObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func appWillResignActive() {
        if blurOnBackgroundEnabled {
            showOverlay()
        }
    }

    @objc private func appDidBecomeActive() {
        if #available(iOS 11.0, *) {
            if !UIScreen.main.isCaptured {
                hideOverlay()
            }
        } else {
            hideOverlay()
        }
    }

    deinit {
        removeScreenCaptureDetection()
        removeAppLifecycleObserver()
        hideOverlay()
    }

    // MARK: - Blur Overlay

    private func showOverlay() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.overlayView == nil else { return }

            guard let keyWindow = Self.keyWindow else { return }

            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = keyWindow.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            let dimView = UIView(frame: keyWindow.bounds)
            dimView.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(blurIntensity) * 0.5)
            dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            let container = UIView(frame: keyWindow.bounds)
            container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addSubview(blurEffectView)
            container.addSubview(dimView)
            container.isUserInteractionEnabled = false

            keyWindow.addSubview(container)
            self.overlayView = container
        }
    }

    private func hideOverlay() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.overlayView?.removeFromSuperview()
            self.overlayView = nil
        }
    }

    private static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }
        return UIApplication.shared.keyWindow
    }
}
