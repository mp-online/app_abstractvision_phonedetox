package com.abstractvision.phonedetox.detox

import org.junit.Assert.assertEquals
import org.junit.Assert.assertThrows
import org.junit.Test

class DetoxSessionSnapshotTest {
    @Test fun parsesAndSerializesValidatedPayload() {
        val payload = mapOf(
            "id" to "session",
            "startedAtEpochMs" to 1_000L,
            "endsAtEpochMs" to 61_000L,
            "blockedPackageNames" to listOf("example.app"),
        )
        val snapshot = DetoxSessionSnapshot.fromArguments(payload, nowEpochMs = 2_000L)
        assertEquals(payload, snapshot.toMap())
    }

    @Test fun rejectsExpiredPayload() {
        assertThrows(IllegalArgumentException::class.java) {
            DetoxSessionSnapshot.fromArguments(
                mapOf(
                    "id" to "session",
                    "startedAtEpochMs" to 1_000L,
                    "endsAtEpochMs" to 2_000L,
                    "blockedPackageNames" to listOf("example.app"),
                ),
                nowEpochMs = 2_000L,
            )
        }
    }
}
