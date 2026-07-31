package com.abstractvision.phonedetox.foreground

object InterventionPackagePolicy {
    private const val PHONE_DETOX_PACKAGE = "com.abstractvision.phonedetox"
    private val exactSafePackages = setOf("com.android.systemui", "com.android.settings")
    private val safeParts = setOf(
        "permissioncontroller",
        "packageinstaller",
        "incallui",
        "telecom",
        "emergency",
        "setupwizard",
        "systemui",
        "recovery",
    )

    fun isConfigurable(packageName: String): Boolean =
        packageName.isNotBlank() &&
            packageName != PHONE_DETOX_PACKAGE &&
            packageName !in exactSafePackages &&
            safeParts.none { packageName.contains(it, ignoreCase = true) }

    fun isTransientOrCritical(
        packageName: String,
        ownPackageName: String,
        dynamicSafePackages: Set<String>,
    ): Boolean =
        packageName == ownPackageName ||
            packageName in dynamicSafePackages ||
            packageName in exactSafePackages ||
            safeParts.any { packageName.contains(it, ignoreCase = true) }
}
