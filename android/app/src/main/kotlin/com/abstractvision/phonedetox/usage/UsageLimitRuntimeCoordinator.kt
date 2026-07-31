package com.abstractvision.phonedetox.usage

class UsageLimitRuntimeCoordinator(
    private val intervalStore: UsageIntervalPersistence,
    private val reachedStore: UsageLimitReachedPersistence,
    private val clock: UsageLimitClock,
    private val scheduler: UsageLimitScheduler,
    private val currentForeground: () -> String?,
    private val isInteractive: () -> Boolean,
    private val isCurrentHome: () -> Boolean,
    private val activeDetoxPackages: () -> Set<String>,
    private val returnHome: () -> Boolean,
) {
    private var runningSinceElapsedMs: Long? = null

    fun reconcileAfterServiceCreation() {
        val existing = intervalStore.read() ?: return
        scheduler.cancel()
        if (existing.phase == UsageIntervalPhase.RUNNING) {
            intervalStore.save(
                existing.copy(
                    phase = UsageIntervalPhase.PAUSED,
                    updatedAtEpochMs = clock.wallTimeMillis(),
                ),
            )
        }
    }

    fun enter(packageName: String, configuredLimitMs: Long) {
        if (!isInteractive()) return
        val existing = intervalStore.read()
        if (existing?.packageName == packageName && existing.phase == UsageIntervalPhase.RUNNING) return
        if (existing != null && existing.packageName != packageName) clearRuntime()
        val now = clock.wallTimeMillis()
        val remaining = existing
            ?.takeIf { it.packageName == packageName && it.configuredLimitMs == configuredLimitMs }
            ?.remainingMs ?: configuredLimitMs
        val startedAt = existing?.takeIf { it.packageName == packageName }?.startedAtEpochMs ?: now
        val snapshot = UsageIntervalSnapshot(
            schemaVersion = UsageIntervalSnapshot.SCHEMA_VERSION,
            packageName = packageName,
            configuredLimitMs = configuredLimitMs,
            remainingMs = remaining,
            phase = UsageIntervalPhase.RUNNING,
            startedAtEpochMs = startedAt,
            updatedAtEpochMs = now,
        )
        if (intervalStore.save(snapshot)) {
            runningSinceElapsedMs = clock.elapsedRealtimeMillis()
            scheduler.schedule(remaining) { onTimeout(packageName) }
        }
    }

    fun leave(packageName: String? = null) {
        val existing = intervalStore.read() ?: return
        if (packageName == null || existing.packageName == packageName) clearRuntime()
    }

    fun pause() {
        val existing = intervalStore.read() ?: return
        if (existing.phase == UsageIntervalPhase.PAUSED) return
        val elapsed = runningSinceElapsedMs?.let { clock.elapsedRealtimeMillis() - it } ?: 0L
        val remaining = (existing.remainingMs - elapsed.coerceAtLeast(0)).coerceAtLeast(1)
        scheduler.cancel()
        runningSinceElapsedMs = null
        intervalStore.save(
            existing.copy(
                remainingMs = remaining,
                phase = UsageIntervalPhase.PAUSED,
                updatedAtEpochMs = clock.wallTimeMillis(),
            ),
        )
    }

    fun clearRuntime() {
        scheduler.cancel()
        runningSinceElapsedMs = null
        intervalStore.clear()
    }

    fun clearAllEnforcement() {
        clearRuntime()
        reachedStore.clear()
    }

    fun shutdown() {
        pause()
        scheduler.cancel()
    }

    private fun onTimeout(expectedPackage: String) {
        scheduler.cancel()
        runningSinceElapsedMs = null
        val interval = intervalStore.read()
        if (
            interval?.packageName != expectedPackage ||
            currentForeground() != expectedPackage ||
            !isInteractive() ||
            !isCurrentHome() ||
            expectedPackage in activeDetoxPackages()
        ) {
            intervalStore.clear()
            return
        }
        val reached = UsageLimitReachedSnapshot(
            schemaVersion = UsageLimitReachedSnapshot.SCHEMA_VERSION,
            packageName = expectedPackage,
            configuredLimitMs = interval.configuredLimitMs,
            reachedAtEpochMs = clock.wallTimeMillis(),
        )
        if (reachedStore.save(reached)) {
            intervalStore.clear()
            returnHome()
        }
    }
}
