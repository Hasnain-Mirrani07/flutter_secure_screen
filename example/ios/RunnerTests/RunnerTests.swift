import Flutter
import UIKit
import XCTest

@testable import flutter_screenshot_guard

class RunnerTests: XCTestCase {

  func testEnableScreenshotBlocking() {
    let plugin = FlutterScreenshotGuardPlugin()
    let call = FlutterMethodCall(methodName: "enableScreenshotBlocking", arguments: nil)
    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertNil(result)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}
