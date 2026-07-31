package com.abstractvision.phonedetox.foreground

class ForegroundPackageClassifier(private val ownPackageName: String) {
    fun isTransientOrCritical(packageName: String, dynamicSafePackages: Set<String>): Boolean =
        InterventionPackagePolicy.isTransientOrCritical(
            packageName,
            ownPackageName,
            dynamicSafePackages,
        )

    fun preservesAdmission(packageName: String, dynamicSafePackages: Set<String>): Boolean =
        packageName != ownPackageName && isTransientOrCritical(packageName, dynamicSafePackages) &&
            packageName != "com.android.settings"
}