package com.abstractvision.phonedetox.usage

data class UsageIntervalSnapshot(
    val schemaVersion: Int,
    val packageName: String,
    val configuredLimitMs: Long,
    val remainingMs: Long,
    val phase: UsageIntervalPhase,
    val startedAtEpochMs: Long,
    val updatedAtEpochMs: Long,
) {
    init {
        require(schemaVersion == SCHEMA_VERSION)
        require(packageName.isNotBlank())
        require(configuredLimitMs > 0)
        require(remainingMs in 1..configuredLimitMs)
        require(startedAtEpochMs > 0)
        require(updatedAtEpochMs >= startedAtEpochMs)
    }

    fun toMap(): Map<String, Any> = mapOf(
        "schemaVersion" to schemaVersion,
        "packageName" to packageName,
        "configuredLimitMs" to configuredLimitMs,
        "remainingMs" to remainingMs,
        "phase" to phase.wireValue,
        "startedAtEpochMs" to startedAtEpochMs,
        "updatedAtEpochMs" to updatedAtEpochMs,
    )

    companion object { const val SCHEMA_VERSION = 1 }
}
