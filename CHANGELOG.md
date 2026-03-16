## 1.0.0

* Initial release.
* **Disable screenshots**: Android via `FLAG_SECURE`; iOS via blur when capture/background.
* **Disable screen recording**: Android via `FLAG_SECURE`; iOS blur when `UIScreen.isCaptured`.
* **Blur app when in background**: Overlay on app switcher / recents (Android & iOS).
* Optional blur intensity (0.0–1.0).
* APIs: `enableSecureMode`, `disableSecureMode`, `enableScreenshotBlocking`, `disableScreenshotBlocking`, `enableBlurOnBackground`, `disableBlurOnBackground`, `setBlurIntensity`.
