package com.example.flutter_screenshot_guard

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

internal class FlutterScreenshotGuardPluginTest {
    @Test
    fun onMethodCall_enableScreenshotBlocking_invokesSuccess() {
        val plugin = FlutterScreenshotGuardPlugin()
        val call = MethodCall("enableScreenshotBlocking", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)
        Mockito.verify(mockResult).success(null)
    }
}
