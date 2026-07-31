package com.abstractvision.phonedetox.detox

import org.junit.Assert.assertEquals
import org.junit.Test

class AccessibilityServiceInitializerTest {
    @Test fun everyDependencyInitializesBeforeReconciliation() {
        val order = mutableListOf<String>()
        AccessibilityServiceInitializer.initialize(
            { order += "session" },
            { order += "rules" },
            { order += "request" },
            { order += "admission" },
            { order += "decision" },
            { order += "reconcile" },
        )
        assertEquals(
            listOf("session", "rules", "request", "admission", "decision", "reconcile"),
            order,
        )
    }
}
