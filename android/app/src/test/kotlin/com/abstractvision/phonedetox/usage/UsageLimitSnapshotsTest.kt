package com.abstractvision.phonedetox.usage

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class UsageLimitSnapshotsTest {
    @Test fun rulesRequireDisclosureThreeAndFixedPresets() {
        val rule = UsageLimitRuleSnapshot("social.app", 15)
        assertEquals(15, rule.limitMinutes)
        assertThrows(IllegalArgumentException::class.java) {
            UsageLimitRuleSnapshot("social.app", 20)
        }
        assertThrows(IllegalArgumentException::class.java) {
            UsageLimitRulesSnapshot(1, true, 2, mapOf(rule.packageName to rule))
        }
    }
}
