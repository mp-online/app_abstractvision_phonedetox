package com.abstractvision.phonedetox

import com.abstractvision.phonedetox.detox.DetoxPlatformHandler
import com.abstractvision.phonedetox.launcher.LauncherPlatformHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var launcherHandler: LauncherPlatformHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        launcherHandler = LauncherPlatformHandler(this, flutterEngine.dartExecutor.binaryMessenger)
        DetoxPlatformHandler(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        launcherHandler?.close()
        launcherHandler = null
        super.onDestroy()
    }
}
