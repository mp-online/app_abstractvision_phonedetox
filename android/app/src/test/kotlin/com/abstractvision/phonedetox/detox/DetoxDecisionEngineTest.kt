package com.abstractvision.phonedetox.detox

import org.junit.Assert.assertEquals
import org.junit.Test

class DetoxDecisionEngineTest {
    private val now = 1_000L
    private val session = DetoxSessionSnapshot("id", 0, 2_000, setOf("blocked.app", "keyboard.app"))
    private val engine = DetoxDecisionEngine("com.abstractvision.phonedetox")

    @Test fun noSessionAllows() = assertDecision(DetoxDecisionEngine.Decision.ALLOW, "blocked.app", null)
    @Test fun expiredSessionClears() = assertDecision(DetoxDecisionEngine.Decision.CLEAR_EXPIRED, "blocked.app", session, 2_000)
    @Test fun blockedPackageBlocks() = assertDecision(DetoxDecisionEngine.Decision.BLOCK, "blocked.app", session)
    @Test fun unblockedPackageAllows() = assertDecision(DetoxDecisionEngine.Decision.ALLOW, "allowed.app", session)
    @Test fun ownPackageAllows() = assertDecision(DetoxDecisionEngine.Decision.ALLOW, "com.abstractvision.phonedetox", session)
    @Test fun systemUiAllows() = assertDecision(DetoxDecisionEngine.Decision.ALLOW, "com.android.systemui", session)
    @Test fun settingsAllows() = assertDecision(DetoxDecisionEngine.Decision.ALLOW, "com.android.settings", session)
    @Test fun inputMethodAllows() = assertEquals(
        DetoxDecisionEngine.Decision.ALLOW,
        engine.evaluate("keyboard.app", session, setOf("keyboard.app"), now),
    )
    @Test fun blankPackageAllows() = assertDecision(DetoxDecisionEngine.Decision.ALLOW, "", session)

    private fun assertDecision(
        expected: DetoxDecisionEngine.Decision,
        packageName: String?,
        value: DetoxSessionSnapshot?,
        at: Long = now,
    ) = assertEquals(expected, engine.evaluate(packageName, value, nowEpochMs = at))
}
