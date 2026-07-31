package com.abstractvision.phonedetox.detox

import android.app.Activity
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class DetoxPlatformHandler(
    private val activity: Activity,
    messenger: BinaryMessenger,
) {
    private val sessionStore = DetoxSessionStore(activity)

    init {
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAccessibilityStatus" -> result.success(accessibilityStatus())
                "openAccessibilitySettings" -> handle(result) {
                    activity.startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                }
                "startDetoxSession" -> handle(result) {
                    if (accessibilityStatus() == STATUS_UNAVAILABLE) {
                        throw PlatformFailure("accessibility_unavailable", "Accessibility settings are unavailable.")
                    }
                    if (accessibilityStatus() != STATUS_ENABLED) {
                        throw PlatformFailure("accessibility_disabled", "Phone Detox Accessibility is disabled.")
                    }
                    val snapshot = try {
                        DetoxSessionSnapshot.fromArguments(call.arguments)
                    } catch (error: IllegalArgumentException) {
                        throw PlatformFailure("invalid_arguments", error.message ?: "Invalid session.")
                    }
                    if (!sessionStore.save(snapshot)) {
                        throw PlatformFailure("session_persistence_failed", "Native session could not be saved.")
                    }
                }
                "stopDetoxSession" -> handle(result) {
                    if (!sessionStore.clear()) {
                        throw PlatformFailure("session_persistence_failed", "Native session could not be cleared.")
                    }
                }
                "getActiveDetoxSession" -> handleWithValue(result) {
                    sessionStore.getActive()?.toMap()
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun accessibilityStatus(): String {
        val settingsIntent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        if (activity.packageManager.resolveActivity(settingsIntent, PackageManager.MATCH_DEFAULT_ONLY) == null) {
            return STATUS_UNAVAILABLE
        }
        val enabled = Settings.Secure.getString(
            activity.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
        ).orEmpty()
        val expected = ComponentName(activity, PhoneDetoxAccessibilityService::class.java)
        return if (enabled.split(':').mapNotNull(ComponentName::unflattenFromString).any { it == expected }) {
            STATUS_ENABLED
        } else {
            STATUS_DISABLED
        }
    }

    private fun handle(result: MethodChannel.Result, action: () -> Unit) =
        handleWithValue(result) { action(); null }

    private fun handleWithValue(result: MethodChannel.Result, action: () -> Any?) {
        try {
            result.success(action())
        } catch (error: PlatformFailure) {
            result.error(error.code, error.message, null)
        } catch (error: SecurityException) {
            result.error("native_failure", error.message, null)
        } catch (error: Exception) {
            result.error("native_failure", error.message, null)
        }
    }

    private class PlatformFailure(val code: String, message: String) : IllegalStateException(message)

    companion object {
        private const val CHANNEL_NAME = "com.abstractvision.phonedetox/detox"
        private const val STATUS_ENABLED = "enabled"
        private const val STATUS_DISABLED = "disabled"
        private const val STATUS_UNAVAILABLE = "unavailable"
    }
}
