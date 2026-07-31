package com.abstractvision.phonedetox.detox

class DetoxDecisionEngine(private val ownPackageName: String) {
    enum class Decision { ALLOW, BLOCK, CLEAR_EXPIRED }

    fun evaluate(
        foregroundPackageName: String?,
        session: DetoxSessionSnapshot?,
        dynamicExemptPackages: Set<String> = emptySet(),
        nowEpochMs: Long = System.currentTimeMillis(),
    ): Decision {
        if (foregroundPackageName.isNullOrBlank() || session == null) return Decision.ALLOW
        if (session.endsAtEpochMs <= nowEpochMs) return Decision.CLEAR_EXPIRED
        if (isExempt(foregroundPackageName, dynamicExemptPackages)) return Decision.ALLOW
        return if (foregroundPackageName in session.blockedPackageNames) Decision.BLOCK else Decision.ALLOW
    }

    private fun isExempt(packageName: String, dynamicExemptPackages: Set<String>): Boolean {
        if (packageName == ownPackageName || packageName in dynamicExemptPackages) return true
        if (packageName in EXACT_EXEMPT_PACKAGES) return true
        return EXEMPT_PACKAGE_PARTS.any { packageName.contains(it, ignoreCase = true) }
    }

    companion object {
        private val EXACT_EXEMPT_PACKAGES = setOf(
            "com.android.systemui",
            "com.android.settings",
        )
        private val EXEMPT_PACKAGE_PARTS = setOf(
            "permissioncontroller",
            "packageinstaller",
            "incallui",
            "telecom",
            "emergency",
            "setupwizard",
            "systemui",
        )
    }
}
