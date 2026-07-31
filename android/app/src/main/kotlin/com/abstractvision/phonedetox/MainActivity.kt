package com.abstractvision.phonedetox

import android.app.role.RoleManager
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val inventoryExecutor = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getLaunchableApps" -> getLaunchableApps(result)
                "isDefaultLauncher" -> result.success(isDefaultLauncher())
                "requestDefaultLauncher" -> handle(result) { requestDefaultLauncher() }
                "launchApp" -> handle(result) { launchApp(call) }
                "openAppDetails" -> handle(result) { openAppDetails(call) }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        inventoryExecutor.shutdown()
        super.onDestroy()
    }

    private fun getLaunchableApps(result: MethodChannel.Result) {
        inventoryExecutor.execute {
            try {
                val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
                val activities = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    packageManager.queryIntentActivities(
                        intent,
                        PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_ALL.toLong()),
                    )
                } else {
                    @Suppress("DEPRECATION")
                    packageManager.queryIntentActivities(intent, PackageManager.MATCH_ALL)
                }
                val apps = activities
                    .asSequence()
                    .filter { it.activityInfo.packageName != packageName }
                    .map {
                        mapOf(
                            "label" to it.loadLabel(packageManager).toString(),
                            "packageName" to it.activityInfo.packageName,
                            "activityName" to it.activityInfo.name,
                        )
                    }
                    .distinctBy { "${it["packageName"]}/${it["activityName"]}" }
                    .toList()
                runOnUiThread { result.success(apps) }
            } catch (error: SecurityException) {
                runOnUiThread {
                    result.error("security_exception", error.message, null)
                }
            } catch (error: Exception) {
                runOnUiThread { result.error("native_failure", error.message, null) }
            }
        }
    }

    private fun isDefaultLauncher(): Boolean {
        val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        val resolved = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.resolveActivity(
                intent,
                PackageManager.ResolveInfoFlags.of(PackageManager.MATCH_DEFAULT_ONLY.toLong()),
            )
        } else {
            @Suppress("DEPRECATION")
            packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
        }
        return resolved?.activityInfo?.packageName == packageName
    }

    private fun requestDefaultLauncher() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(RoleManager::class.java)
            if (roleManager.isRoleAvailable(RoleManager.ROLE_HOME) &&
                !roleManager.isRoleHeld(RoleManager.ROLE_HOME)
            ) {
                startActivity(roleManager.createRequestRoleIntent(RoleManager.ROLE_HOME))
                return
            }
        }
        startActivity(Intent(Settings.ACTION_HOME_SETTINGS))
    }

    private fun launchApp(call: MethodCall) {
        val packageName = requiredStringArgument(call, "packageName")
        val activityName = requiredStringArgument(call, "activityName")
        val intent = Intent(Intent.ACTION_MAIN).apply {
            component = ComponentName(packageName, activityName)
            addCategory(Intent.CATEGORY_LAUNCHER)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        if (packageManager.resolveActivity(intent, 0) == null) {
            throw ActivityNotFound("The selected launcher activity is no longer available.")
        }
        startActivity(intent)
    }

    private fun openAppDetails(call: MethodCall) {
        val packageName = requiredStringArgument(call, "packageName")
        startActivity(
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

    private fun handle(result: MethodChannel.Result, action: () -> Unit) {
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
            result.error("native_failure", error.message, null)
        }
    }

    private class InvalidArguments(message: String) : IllegalArgumentException(message)
    private class ActivityNotFound(message: String) : IllegalStateException(message)

    companion object {
        private const val CHANNEL_NAME = "com.abstractvision.phonedetox/launcher"
    }
}