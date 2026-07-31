package com.abstractvision.phonedetox.detox

internal object AccessibilityServiceInitializer {
    fun initialize(
        initializeSessionStore: () -> Unit,
        initializeMindfulRulesStore: () -> Unit,
        initializeMindfulRequestStore: () -> Unit,
        initializeMindfulAdmissionStore: () -> Unit,
        initializeDecisionDependencies: () -> Unit,
        reconcileAfterInitialization: () -> Unit,
        initializeUsageLimitDependencies: () -> Unit = {},
    ) {
        initializeSessionStore()
        initializeMindfulRulesStore()
        initializeMindfulRequestStore()
        initializeMindfulAdmissionStore()
        initializeUsageLimitDependencies()
        initializeDecisionDependencies()
        reconcileAfterInitialization()
    }
}
