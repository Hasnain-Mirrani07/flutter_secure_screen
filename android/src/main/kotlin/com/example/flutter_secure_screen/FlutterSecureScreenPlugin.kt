package com.example.flutter_secure_screen

import android.app.Activity
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * FlutterSecureScreenPlugin - Secure screen protection for fintech apps.
 *
 * Features:
 * - Disable screenshots and screen recording (FLAG_SECURE)
 * - Blur/obscure app when in background (shown in app switcher)
 */
class FlutterSecureScreenPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var overlayView: android.view.View? = null

    private var screenshotBlockingEnabled = false
    private var blurOnBackgroundEnabled = false
    private var blurIntensity = 0.5

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_secure_screen")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.lifecycle.addObserver(object : androidx.lifecycle.DefaultLifecycleObserver {
            override fun onResume(owner: androidx.lifecycle.LifecycleOwner) {
                activity?.runOnUiThread { hideOverlay() }
            }

            override fun onPause(owner: androidx.lifecycle.LifecycleOwner) {
                activity?.runOnUiThread {
                    if (blurOnBackgroundEnabled) {
                        showOverlay()
                    }
                }
            }
        })
    }

    override fun onDetachedFromActivityForConfigChanges() {
        if (blurOnBackgroundEnabled) {
            showOverlay()
        }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        if (blurOnBackgroundEnabled) {
            hideOverlay()
        }
    }

    override fun onDetachedFromActivity() {
        hideOverlay()
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "enableScreenshotBlocking" -> {
                screenshotBlockingEnabled = true
                updateWindowFlags()
                result.success(null)
            }
            "disableScreenshotBlocking" -> {
                screenshotBlockingEnabled = false
                updateWindowFlags()
                result.success(null)
            }
            "enableBlurOnBackground" -> {
                blurOnBackgroundEnabled = true
                result.success(null)
            }
            "disableBlurOnBackground" -> {
                blurOnBackgroundEnabled = false
                hideOverlay()
                result.success(null)
            }
            "enableSecureMode" -> {
                screenshotBlockingEnabled = true
                blurOnBackgroundEnabled = true
                updateWindowFlags()
                result.success(null)
            }
            "disableSecureMode" -> {
                screenshotBlockingEnabled = false
                blurOnBackgroundEnabled = false
                updateWindowFlags()
                hideOverlay()
                result.success(null)
            }
            "setBlurIntensity" -> {
                blurIntensity = (call.arguments as? Map<*, *>)?.let { args ->
                    (args["intensity"] as? Number)?.toDouble()?.coerceIn(0.0, 1.0)
                } ?: blurIntensity
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun updateWindowFlags() {
        activity?.runOnUiThread {
            activity?.window?.let { window ->
                if (screenshotBlockingEnabled) {
                    window.setFlags(
                        android.view.WindowManager.LayoutParams.FLAG_SECURE,
                        android.view.WindowManager.LayoutParams.FLAG_SECURE
                    )
                } else {
                    window.clearFlags(android.view.WindowManager.LayoutParams.FLAG_SECURE)
                }
            }
        }
    }

    private fun showOverlay() {
        val act = activity ?: return
        if (overlayView != null) return

        act.runOnUiThread {
            val rootView = act.window?.decorView as? ViewGroup ?: return@runOnUiThread

            val overlay = FrameLayout(act).apply {
                setBackgroundColor(
                    android.graphics.Color.argb(
                        (blurIntensity * 230).toInt(),
                        0,
                        0,
                        0
                    )
                )
                id = android.view.View.generateViewId()
            }

            val params = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            rootView.addView(overlay, params)
            overlayView = overlay
        }
    }

    private fun hideOverlay() {
        activity?.runOnUiThread {
            overlayView?.let { view ->
                (view.parent as? ViewGroup)?.removeView(view)
                overlayView = null
            }
        }
    }
}
