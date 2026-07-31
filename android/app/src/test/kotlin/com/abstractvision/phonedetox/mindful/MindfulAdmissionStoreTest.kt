package com.abstractvision.phonedetox.mindful

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class MindfulAdmissionStoreTest {
    @Test fun phaseWireValuesRoundTrip() {
        MindfulAdmissionPhase.entries.forEach { phase ->
            assertEquals(phase, MindfulAdmissionPhase.fromWire(phase.wireValue))
        }
    }

    @Test fun schemaTwoSnapshotDecodes() {
        val value = decode()
        assertEquals("social.app", value?.packageName)
        assertEquals(MindfulAdmissionPhase.AWAITING_TARGET, value?.phase)
        assertEquals(25_000L, value?.targetDeadlineEpochMs)
    }

    @Test fun oldSchemaAndUnknownPhaseAreRejected() {
        assertNull(decode(schemaVersion = 1))
        assertNull(decode(phase = "futurePhase"))
    }

    @Test fun corruptedAdmissionIsRejected() {
        assertNull(decode(packageName = ""))
        assertNull(decode(targetDeadlineEpochMs = 9_999))
        assertNull(decode(expiresAtEpochMs = 20_000))
    }

    @Test fun awaitingUsesTargetDeadlineAndActiveUsesSafetyExpiration() {
        val awaiting = checkNotNull(decode())
        assertFalse(awaiting.isExpiredAt(24_999))
        assertTrue(awaiting.isExpiredAt(25_000))

        val active = awaiting.activate()
        assertFalse(active.isExpiredAt(99_999))
        assertTrue(active.isExpiredAt(100_000))
    }

    private fun decode(
        schemaVersion: Int = MindfulAdmissionStore.SCHEMA_VERSION,
        packageName: String? = "social.app",
        phase: String? = MindfulAdmissionPhase.AWAITING_TARGET.wireValue,
        grantedAtEpochMs: Long = 10_000,
        targetDeadlineEpochMs: Long = 25_000,
        expiresAtEpochMs: Long = 100_000,
    ) = MindfulAdmissionStore.decode(
        schemaVersion,
        packageName,
        phase,
        grantedAtEpochMs,
        targetDeadlineEpochMs,
        expiresAtEpochMs,
    )
}