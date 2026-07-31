package com.abstractvision.phonedetox

import androidx.activity.result.contract.ActivityResultContracts
import com.abstractvision.phonedetox.detox.DetoxPlatformHandler
import com.abstractvision.phonedetox.launcher.LauncherPlatformHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
    private var launcherHandler: LauncherPlatformHandler? = null

    // Activity Result launchers must be registered before the Activity is STARTED.
    // Property registration happens during Activity construction, before Flutter starts.
    private val homeRoleRequestLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult(),
    ) { activityResult ->
        launcherHandler?.onHomeRoleActivityResult(activityResult.resultCode)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        launcherHandler = LauncherPlatformHandler(
            this,
            flutterEngine.dartExecutor.binaryMessenger,
            homeRoleRequestLauncher::launch,
        )
        DetoxPlatformHandler(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        launcherHandler?.close()
        launcherHandler = null
        super.onDestroy()
    }
}
