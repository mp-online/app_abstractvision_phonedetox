package com.abstractvision.phonedetox.foreground

class ForegroundPackageClassifier(private val ownPackageName: String) {
    fun isTransientOrCritical(packageName: String, dynamicSafePackages: Set<String>): Boolean {
        if (packageName == ownPackageName || packageName in dynamicSafePackages) return true
        if (packageName in EXACT_SAFE_PACKAGES) return true
        return SAFE_PARTS.any { packageName.contains(it, ignoreCase = true) }
    }

    fun preservesAdmission(packageName: String, dynamicSafePackages: Set<String>): Boolean =
        packageName != ownPackageName && isTransientOrCritical(packageName, dynamicSafePackages) &&
            packageName != "com.android.settings"

    companion object {
        private val EXACT_SAFE_PACKAGES = setOf("com.android.systemui", "com.android.settings")
        private val SAFE_PARTS = setOf(
            "permissioncontroller", "packageinstaller", "incallui", "telecom", "emergency",
            "setupwizard", "systemui", "recovery",
        )
    }
}
