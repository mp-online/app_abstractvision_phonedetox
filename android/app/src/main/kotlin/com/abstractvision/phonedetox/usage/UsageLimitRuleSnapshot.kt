package com.abstractvision.phonedetox.usage

import com.abstractvision.phonedetox.foreground.InterventionPackagePolicy

data class UsageLimitRuleSnapshot(
    val packageName: String,
    val limitMinutes: Int,
) {
    init {
        require(PACKAGE_PATTERN.matches(packageName))
        require(InterventionPackagePolicy.isConfigurable(packageName))
        require(limitMinutes in SUPPORTED_MINUTES)
    }

    companion object {
        val SUPPORTED_MINUTES = setOf(5, 10, 15, 30, 60)
        private val PACKAGE_PATTERN =
            Regex("^[A-Za-z_][A-Za-z0-9_]*(\\.[A-Za-z_][A-Za-z0-9_]*)+$")
    }
}
