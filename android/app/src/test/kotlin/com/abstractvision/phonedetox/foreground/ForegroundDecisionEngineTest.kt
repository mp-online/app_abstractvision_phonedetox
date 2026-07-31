package com.abstractvision.phonedetox.foreground

import com.abstractvision.phonedetox.detox.DetoxSessionSnapshot
import com.abstractvision.phonedetox.mindful.MindfulAdmissionSnapshot
import com.abstractvision.phonedetox.mindful.MindfulMode
import com.abstractvision.phonedetox.mindful.MindfulRuleSnapshot
import com.abstractvision.phonedetox.mindful.MindfulRulesSnapshot
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ForegroundDecisionEngineTest {
    private val engine = ForegroundDecisionEngine("com.abstractvision.phonedetox")
    private val rule = MindfulRuleSnapshot("social.app", MindfulMode.PAUSE, 10)
    private val mindful = MindfulRulesSnapshot(1, true, 2, mapOf(rule.packageName to rule))
    private val now = 10_000L

    @Test fun blankPackageAllows() = assertEquals(ForegroundDecision.Allow, evaluate(""))

    @Test fun detoxHardBlockWinsOverMindful() {
        val session = DetoxSessionSnapshot("session", 1, 20_000, setOf("social.app"))
        assertEquals(ForegroundDecision.ReturnHomeForDetox, evaluate("social.app", session = session))
    }

    @Test fun mindfulRequiresHeldHomeAndDisclosureTwo() {
        assertEquals(ForegroundDecision.Allow, evaluate("social.app", home = false))
        val old = mindful.copy(enabled = false, disclosureVersion = 1)
        assertEquals(ForegroundDecision.Allow, evaluate("social.app", mindful = old))
        assertTrue(evaluate("social.app") is ForegroundDecision.ReturnHomeForMindfulOpening)
    }

    @Test fun admissionAllowsSamePackageAndClearsOnMeaningfulTransition() {
        val admission = MindfulAdmissionSnapshot("social.app", now - 1, now + 1000)
        assertEquals(ForegroundDecision.Allow, evaluate("social.app", admission = admission))
        assertEquals(ForegroundDecision.ClearAdmissionAndAllow, evaluate("other.app", admission = admission))
        assertEquals(ForegroundDecision.Allow, evaluate("com.android.systemui", admission = admission))
        assertEquals(
            ForegroundDecision.ClearAdmissionAndAllow,
            engine.evaluate("dialer.app", null, mindful, null, admission, true, setOf("dialer.app"), setOf("dialer.app"), now),
        )
    }

    @Test fun criticalPackagesAlwaysAllow() {
        val session = DetoxSessionSnapshot("session", 1, 20_000, setOf("com.android.settings"))
        assertEquals(ForegroundDecision.Allow, evaluate("com.android.settings", session = session))
    }

    private fun evaluate(
        packageName: String,
        session: DetoxSessionSnapshot? = null,
        mindful: MindfulRulesSnapshot? = this.mindful,
        admission: MindfulAdmissionSnapshot? = null,
        home: Boolean = true,
    ) = engine.evaluate(
        packageName, session, mindful, null, admission, home, emptySet(), emptySet(), now,
    )
}
