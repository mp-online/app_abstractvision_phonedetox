package com.abstractvision.phonedetox.launcher

import android.app.Activity
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class LauncherPlatformHandler(
    private val activity: Activity,
    messenger: BinaryMessenger,
    launchHomeRoleRequest: (Intent) -> Unit,
    homeRoleGateway: HomeRoleGateway = AndroidHomeRoleGateway(activity),
) {
    private val inventoryExecutor = Executors.newSingleThreadExecutor()
    private val homeRoleCoordinator = HomeRoleRequestCoordinator(
        homeRoleGateway,
        launchHomeRoleRequest,
    )

    init {
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "getLaunchableApps" -> getLaunchableApps(result)
                "getHomeRoleStatus" -> handleValue(result) {
                    homeRoleGateway.getStatus().wireValue
                }
                "requestHomeRole" -> requestHomeRole(result)
                "openHomeSettings" -> handle(result, "home_settings_unavailable") {
                    if (!homeRoleGateway.openHomeSettings()) {
                        throw HomeSettingsUnavailable()
                    }
                }
                "launchApp" -> handle(result) { launchApp(call) }
                "openAppDetails" -> handle(result) { openAppDetails(call) }
                else -> result.notImplemented()
            }
        }
    }

    fun onHomeRoleActivityResult(resultCode: Int) {
        homeRoleCoordinator.onActivityResult(resultCode)
    }

    fun close() {
        homeRoleCoordinator.close()
        inventoryExecutor.shutdown()
    }

    private fun requestHomeRole(result: MethodChannel.Result) {
        homeRoleCoordinator.request { requestResult ->
            requestResult.fold(
                onSuccess = { result.success(it.wireValue) },
                onFailure = {
                    val code = if (it is HomeRoleRequestCoordinator.RequestInProgressException) {
                        "home_role_request_in_progress"
                    } else {
                        "home_role_request_failed"
                    }
                    result.error(code, it.message, null)
                },
            )
        }
    }

    private fun getLaunchableApps(result: MethodChannel.Result) {
        inventoryExecutor.execute {
            try {
                val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
                val activities = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    activity.packageManager.queryIntentActivities(
                        intent,
                        PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_ALL.toLong()),
                    )
                } else {
                    @Suppress("DEPRECATION")
                    activity.packageManager.queryIntentActivities(intent, PackageManager.MATCH_ALL)
                }
                val apps = activities.asSequence()
                    .filter { it.activityInfo.packageName != activity.packageName }
                    .map {
                        mapOf(
                            "label" to it.loadLabel(activity.packageManager).toString(),
                            "packageName" to it.activityInfo.packageName,
                            "activityName" to it.activityInfo.name,
                        )
                    }
                    .distinctBy { "${it["packageName"]}/${it["activityName"]}" }
                    .toList()
                activity.runOnUiThread { result.success(apps) }
            } catch (error: SecurityException) {
                activity.runOnUiThread { result.error("security_exception", error.message, null) }
            } catch (error: Exception) {
                activity.runOnUiThread { result.error("native_failure", error.message, null) }
            }
        }
    }

    private fun launchApp(call: MethodCall) {
        val packageName = requiredStringArgument(call, "packageName")
        val activityName = requiredStringArgument(call, "activityName")
        val intent = Intent(Intent.ACTION_MAIN).apply {
            component = ComponentName(packageName, activityName)
            addCategory(Intent.CATEGORY_LAUNCHER)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        if (activity.packageManager.resolveActivity(intent, 0) == null) {
            throw ActivityNotFound("The selected launcher activity is no longer available.")
        }
        activity.startActivity(intent)
    }

    private fun openAppDetails(call: MethodCall) {
        val packageName = requiredStringArgument(call, "packageName")
        activity.startActivity(
            Intent(
                Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                Uri.fromParts("package", packageName, null),
            ),
        )
    }

    private fun requiredStringArgument(call: MethodCall, name: String): String {
        val value = call.argument<String>(name)
        if (value.isNullOrBlank()) throw InvalidArguments("Missing $name.")
        return value
    }

    private fun handle(
        result: MethodChannel.Result,
        fallbackCode: String = "native_failure",
        action: () -> Unit,
    ) {
        try {
            action()
            result.success(null)
        } catch (error: InvalidArguments) {
            result.error("invalid_arguments", error.message, null)
        } catch (error: ActivityNotFound) {
            result.error("activity_not_found", error.message, null)
        } catch (error: SecurityException) {
            result.error("security_exception", error.message, null)
        } catch (error: Exception) {
            result.error(fallbackCode, error.message, null)
        }
    }

    private fun handleValue(result: MethodChannel.Result, action: () -> String) {
        try {
            result.success(action())
        } catch (error: Exception) {
            result.error("native_failure", error.message, null)
        }
    }

    private class InvalidArguments(message: String) : IllegalArgumentException(message)
    private class ActivityNotFound(message: String) : IllegalStateException(message)
    private class HomeSettingsUnavailable : IllegalStateException("No Android Home settings screen is available.")

    companion object {
        private const val CHANNEL_NAME = "com.abstractvision.phonedetox/launcher"
    }
}
