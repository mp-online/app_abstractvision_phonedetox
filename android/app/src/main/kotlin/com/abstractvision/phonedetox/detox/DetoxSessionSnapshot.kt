package com.abstractvision.phonedetox.detox

data class DetoxSessionSnapshot(
    val id: String,
    val startedAtEpochMs: Long,
    val endsAtEpochMs: Long,
    val blockedPackageNames: Set<String>,
) {
    fun validate(nowEpochMs: Long = System.currentTimeMillis()) {
        require(id.isNotBlank()) { "Session ID must not be blank." }
        require(endsAtEpochMs > startedAtEpochMs) { "Session end must be after its start." }
        require(endsAtEpochMs > nowEpochMs) { "Session must not be expired." }
        require(endsAtEpochMs - startedAtEpochMs <= MAX_DURATION_MS) {
            "Session duration must not exceed 480 minutes."
        }
        require(blockedPackageNames.isNotEmpty() && blockedPackageNames.none { it.isBlank() }) {
            "Blocked package names must be non-empty."
        }
    }

    fun toMap(): Map<String, Any> = mapOf(
        "id" to id,
        "startedAtEpochMs" to startedAtEpochMs,
        "endsAtEpochMs" to endsAtEpochMs,
        "blockedPackageNames" to blockedPackageNames.sorted(),
    )

    companion object {
        private const val MAX_DURATION_MS = 480L * 60L * 1000L

        fun fromArguments(arguments: Any?, nowEpochMs: Long = System.currentTimeMillis()): DetoxSessionSnapshot {
            val map = arguments as? Map<*, *> ?: throw IllegalArgumentException("Session must be a map.")
            val id = map["id"] as? String ?: throw IllegalArgumentException("Missing session ID.")
            val startedAt = (map["startedAtEpochMs"] as? Number)?.toLong()
                ?: throw IllegalArgumentException("Missing session start.")
            val endsAt = (map["endsAtEpochMs"] as? Number)?.toLong()
                ?: throw IllegalArgumentException("Missing session end.")
            val packages = map["blockedPackageNames"] as? List<*>
                ?: throw IllegalArgumentException("Missing blocked packages.")
            if (packages.any { it !is String }) {
                throw IllegalArgumentException("Invalid blocked package.")
            }
            return DetoxSessionSnapshot(id, startedAt, endsAt, packages.filterIsInstance<String>().toSet())
                .also { it.validate(nowEpochMs) }
        }
    }
}
