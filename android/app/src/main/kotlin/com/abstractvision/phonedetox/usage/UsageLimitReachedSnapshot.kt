package com.abstractvision.phonedetox.usage

data class UsageLimitReachedSnapshot(
    val schemaVersion: Int,
    val packageName: String,
    val configuredLimitMs: Long,
    val reachedAtEpochMs: Long,
) {
    init {
        require(schemaVersion == SCHEMA_VERSION)
        require(packageName.isNotBlank())
        require(configuredLimitMs > 0)
        require(reachedAtEpochMs > 0)
    }

    fun toMap(): Map<String, Any> = mapOf(
        "schemaVersion" to schemaVersion,
        "packageName" to packageName,
        "configuredLimitMs" to configuredLimitMs,
        "reachedAtEpochMs" to reachedAtEpochMs,
    )

    companion object { const val SCHEMA_VERSION = 1 }
}
