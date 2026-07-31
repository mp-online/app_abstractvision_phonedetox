package com.abstractvision.phonedetox.foreground

import com.abstractvision.phonedetox.detox.DetoxSessionSnapshot
import com.abstractvision.phonedetox.mindful.MindfulAdmissionPhase
import com.abstractvision.phonedetox.mindful.MindfulAdmissionSnapshot
import com.abstractvision.phonedetox.mindful.MindfulLaunchRequestSnapshot
import com.abstractvision.phonedetox.mindful.MindfulMode
import com.abstractvision.phonedetox.mindful.MindfulRuleSnapshot
import com.abstractvision.phonedetox.mindful.MindfulRulesSnapshot
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ForegroundDecisionEngineTest {
    private val ownPackage = "com.abstractvision.phonedetox"
    private val engine = ForegroundDecisionEngine(ownPackage)
    private val rule = MindfulRuleSnapshot("social.app", MindfulMode.PAUSE, 10)
    private val mindful = MindfulRulesSnapshot(1, true, 2, mapOf(rule.packageName to rule))
    private val now = 10_000L

    @Test fun blankPackageAllows() = assertEquals(ForegroundDecision.Allow, evaluate(""))

    @Test fun detoxHardBlockWinsOverBothAdmissionPhases() {
        val session = DetoxSessionSnapshot("session", 1, 20_000, setOf("social.app"))
        assertEquals(
            ForegroundDecision.ReturnHomeForDetox,
            evaluate("social.app", session = session, admission = awaitingAdmission()),
        )
        assertEquals(
            ForegroundDecision.ReturnHomeForDetox,
            evaluate("social.app", session = session, admission = activeAdmission()),
        )
    }

    @Test fun mindfulRequiresHeldHomeAndDisclosureTwo() {
        assertEquals(ForegroundDecision.Allow, evaluate("social.app", home = false))
        val old = mindful.copy(enabled = false, disclosureVersion = 1)
        assertEquals(ForegroundDecision.Allow, evaluate("social.app", mindful = old))
        assertTrue(evaluate("social.app") is ForegroundDecision.ReturnHomeForMindfulOpening)
    }

    @Test fun awaitingAdmissionPreservesPhoneDetoxAndTransientSurfaces() {
        val admission = awaitingAdmission()
        assertEquals(ForegroundDecision.Allow, evaluate(ownPackage, admission = admission))
        assertEquals(
            ForegroundDecision.Allow,
            evaluate("keyboard.app", admission = admission, dynamicSafe = setOf("keyboard.app")),
        )
        assertEquals(ForegroundDecision.Allow, evaluate("com.android.systemui", admission = admission))
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            engine.evaluate(
                "dialer.app",
                null,
                mindful,
                null,
                admission,
                true,
                setOf("dialer.app"),
                setOf("dialer.app"),
                now,
            ),
        )
        assertEquals(
            ForegroundDecision.Allow,
            evaluate("com.google.android.permissioncontroller", admission = admission),
        )
    }

    @Test fun awaitingAdmissionActivatesTargetAndClearsForOtherAppOrDeadline() {
        val admission = awaitingAdmission()
        val activation = evaluate("social.app", admission = admission)
        assertTrue(activation is ForegroundDecision.ActivateAdmissionAndAllow)
        assertEquals(
            MindfulAdmissionPhase.ACTIVE,
            (activation as ForegroundDecision.ActivateAdmissionAndAllow).admission.phase,
        )
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            evaluate("other.app", admission = admission),
        )
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            evaluate("social.app", admission = admission, at = admission.targetDeadlineEpochMs),
        )
    }

    @Test fun activeAdmissionPreservesTargetAndTransientSurfaces() {
        val admission = activeAdmission()
        assertEquals(ForegroundDecision.Allow, evaluate("social.app", admission = admission))
        assertEquals(
            ForegroundDecision.Allow,
            evaluate("keyboard.app", admission = admission, dynamicSafe = setOf("keyboard.app")),
        )
        assertEquals(ForegroundDecision.Allow, evaluate("com.android.systemui", admission = admission))
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            engine.evaluate(
                "dialer.app",
                null,
                mindful,
                null,
                admission,
                true,
                setOf("dialer.app"),
                setOf("dialer.app"),
                now,
            ),
        )
        assertEquals(
            ForegroundDecision.Allow,
            evaluate("com.google.android.permissioncontroller", admission = admission),
        )
    }

    @Test fun activeAdmissionClearsOnHomeSettingsOtherAppAndExpiration() {
        val admission = activeAdmission()
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            evaluate(ownPackage, admission = admission),
        )
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            evaluate("com.android.settings", admission = admission),
        )
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            evaluate("other.app", admission = admission),
        )
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            evaluate("social.app", admission = admission, at = admission.expiresAtEpochMs),
        )
    }

    @Test fun confirmedChromeSequenceDoesNotCreateAnotherRequestOrReturnHome() {
        val chromeRule = MindfulRuleSnapshot("com.android.chrome", MindfulMode.PAUSE, 10)
        val chromeMindful = MindfulRulesSnapshot(
            1,
            true,
            2,
            mapOf(chromeRule.packageName to chromeRule),
        )
        var pendingRequest: MindfulLaunchRequestSnapshot? = null
        var admission: MindfulAdmissionSnapshot? = MindfulAdmissionSnapshot(
            packageName = chromeRule.packageName,
            phase = MindfulAdmissionPhase.AWAITING_TARGET,
            grantedAtEpochMs = now,
            targetDeadlineEpochMs = now + 15_000,
            expiresAtEpochMs = now + 12 * 60 * 60 * 1000,
        )
        var homeInvocations = 0

        fun dispatch(packageName: String) {
            when (val decision = engine.evaluate(
                packageName,
                null,
                chromeMindful,
                pendingRequest,
                admission,
                true,
                emptySet(),
                emptySet(),
                now + 1,
            )) {
                ForegroundDecision.ClearAdmissionAndAllow -> admission = null
                is ForegroundDecision.ActivateAdmissionAndAllow -> admission = decision.admission
                is ForegroundDecision.ReturnHomeForMindfulOpening -> {
                    pendingRequest = decision.request
                    homeInvocations++
                }
                ForegroundDecision.ReturnHomeForDetox -> homeInvocations++
                else -> Unit
            }
        }

        dispatch(ownPackage)
        assertEquals(MindfulAdmissionPhase.AWAITING_TARGET, admission?.phase)
        dispatch(chromeRule.packageName)
        assertEquals(MindfulAdmissionPhase.ACTIVE, admission?.phase)
        dispatch(chromeRule.packageName)

        assertEquals(null, pendingRequest)
        assertEquals(0, homeInvocations)
        assertEquals(MindfulAdmissionPhase.ACTIVE, admission?.phase)
    }

    @Test fun criticalPackagesAlwaysAllow() {
        val session = DetoxSessionSnapshot("session", 1, 20_000, setOf("com.android.settings"))
        assertEquals(ForegroundDecision.Allow, evaluate("com.android.settings", session = session))
    }

    private fun awaitingAdmission() = MindfulAdmissionSnapshot(
        "social.app",
        MindfulAdmissionPhase.AWAITING_TARGET,
        now - 1,
        now + 15_000,
        now + 12 * 60 * 60 * 1000,
    )

    private fun activeAdmission() = awaitingAdmission().activate()

    private fun evaluate(
        packageName: String,
        session: DetoxSessionSnapshot? = null,
        mindful: MindfulRulesSnapshot? = this.mindful,
        admission: MindfulAdmissionSnapshot? = null,
        home: Boolean = true,
        dynamicSafe: Set<String> = emptySet(),
        at: Long = now,
    ) = engine.evaluate(
        packageName,
        session,
        mindful,
        null,
        admission,
        home,
        dynamicSafe,
        emptySet(),
        at,
    )
}