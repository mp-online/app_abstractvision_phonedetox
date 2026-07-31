package com.abstractvision.phonedetox.usage

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

class UsageLimitRuntimeCoordinatorTest {
    private val intervals = FakeIntervals()
    private val reached = FakeReached()
    private val clock = FakeClock()
    private val scheduler = FakeScheduler()
    private var foreground: String? = "social.app"
    private var interactive = true
    private var home = true
    private var detox = emptySet<String>()
    private var homeCalls = 0
    private val coordinator = UsageLimitRuntimeCoordinator(
        intervals,
        reached,
        clock,
        scheduler,
        { foreground },
        { interactive },
        { home },
        { detox },
        { homeCalls++; true },
    )

    @Test fun oneContinuousIntervalPausesUsingMonotonicElapsedTime() {
        coordinator.enter("social.app", 900_000)
        assertEquals(900_000L, scheduler.delay)
        clock.elapsed = 120_000
        clock.wall = 121_000
        coordinator.pause()
        assertEquals(780_000L, intervals.value?.remainingMs)
        assertEquals(UsageIntervalPhase.PAUSED, intervals.value?.phase)
        assertNull(scheduler.action)
    }

    @Test fun timeoutPersistsReachedLockBeforeReturningHome() {
        coordinator.enter("social.app", 300_000)
        scheduler.fire()
        assertEquals("social.app", reached.value?.packageName)
        assertNull(intervals.value)
        assertEquals(1, homeCalls)
    }

    @Test fun timeoutDoesNotInterfereAfterHomeRoleLossOrStrictBlock() {
        coordinator.enter("social.app", 300_000)
        home = false
        scheduler.fire()
        assertNull(reached.value)
        assertEquals(0, homeCalls)

        home = true
        coordinator.enter("social.app", 300_000)
        detox = setOf("social.app")
        scheduler.fire()
        assertNull(reached.value)
        assertTrue(intervals.value == null)
    }

    private class FakeIntervals : UsageIntervalPersistence {
        var value: UsageIntervalSnapshot? = null
        override fun save(value: UsageIntervalSnapshot) = true.also { this.value = value }
        override fun read() = value
        override fun clear() = true.also { value = null }
    }

    private class FakeReached : UsageLimitReachedPersistence {
        var value: UsageLimitReachedSnapshot? = null
        override fun save(value: UsageLimitReachedSnapshot) = true.also { this.value = value }
        override fun read() = value
        override fun clear() = true.also { value = null }
    }

    private class FakeClock : UsageLimitClock {
        var wall = 1_000L
        var elapsed = 0L
        override fun wallTimeMillis() = wall
        override fun elapsedRealtimeMillis() = elapsed
    }

    private class FakeScheduler : UsageLimitScheduler {
        var delay: Long? = null
        var action: (() -> Unit)? = null
        override fun schedule(delayMs: Long, action: () -> Unit) {
            delay = delayMs
            this.action = action
        }
        override fun cancel() { action = null }
        fun fire() { val pending = action; action = null; pending?.invoke() }
    }
}
