package com.abstractvision.phonedetox.mindful

import java.util.UUID

enum class MindfulMode(val wireValue: String) {
    PAUSE("pause"),
    PAUSE_AND_INTENTION("pauseAndIntention");

    companion object {
        fun fromWire(value: String): MindfulMode? = entries.firstOrNull { it.wireValue == value }
    }
}

data class MindfulRuleSnapshot(
    val packageName: String,
    val mode: MindfulMode,
    val delaySeconds: Int,
) {
    init {
        require(packageName.isNotBlank())
        require(delaySeconds in SUPPORTED_DELAYS)
    }

    companion object { val SUPPORTED_DELAYS = setOf(5, 10, 15, 30) }
}

data class MindfulRulesSnapshot(
    val schemaVersion: Int,
    val enabled: Boolean,
    val disclosureVersion: Int,
    val rules: Map<String, MindfulRuleSnapshot>,
) {
    init {
        require(schemaVersion == 1)
        require(rules.size <= 500)
        require(rules.keys.all { it == rules[it]?.packageName })
        require(!enabled || disclosureVersion >= 2)
    }
}

data class MindfulLaunchRequestSnapshot(
    val requestId: String,
    val packageName: String,
    val source: String,
    val mode: MindfulMode,
    val createdAtEpochMs: Long,
    val availableAtEpochMs: Long,
    val expiresAtEpochMs: Long,
) {
    init {
        require(requestId.isNotBlank() && packageName.isNotBlank())
        require(source == "launcher" || source == "external")
        require(createdAtEpochMs <= availableAtEpochMs)
        require(availableAtEpochMs < expiresAtEpochMs)
    }

    fun toMap(): Map<String, Any> = mapOf(
        "requestId" to requestId,
        "packageName" to packageName,
        "source" to source,
        "mode" to mode.wireValue,
        "createdAtEpochMs" to createdAtEpochMs,
        "availableAtEpochMs" to availableAtEpochMs,
        "expiresAtEpochMs" to expiresAtEpochMs,
    )

    companion object {
        fun create(rule: MindfulRuleSnapshot, source: String, nowEpochMs: Long) =
            MindfulLaunchRequestSnapshot(
                requestId = UUID.randomUUID().toString(),
                packageName = rule.packageName,
                source = source,
                mode = rule.mode,
                createdAtEpochMs = nowEpochMs,
                availableAtEpochMs = nowEpochMs + rule.delaySeconds * 1000L,
                expiresAtEpochMs = nowEpochMs + 5 * 60 * 1000L,
            )
    }
}

enum class MindfulAdmissionPhase(val wireValue: String) {
    AWAITING_TARGET("awaitingTarget"),
    ACTIVE("active");

    companion object {
        fun fromWire(value: String): MindfulAdmissionPhase? =
            entries.firstOrNull { it.wireValue == value }
    }
}

data class MindfulAdmissionSnapshot(
    val packageName: String,
    val phase: MindfulAdmissionPhase,
    val grantedAtEpochMs: Long,
    val targetDeadlineEpochMs: Long,
    val expiresAtEpochMs: Long,
) {
    init {
        require(packageName.isNotBlank())
        require(grantedAtEpochMs < targetDeadlineEpochMs)
        require(targetDeadlineEpochMs <= expiresAtEpochMs)
    }

    fun activate(): MindfulAdmissionSnapshot = copy(phase = MindfulAdmissionPhase.ACTIVE)

    fun isExpiredAt(nowEpochMs: Long): Boolean = when (phase) {
        MindfulAdmissionPhase.AWAITING_TARGET -> targetDeadlineEpochMs <= nowEpochMs
        MindfulAdmissionPhase.ACTIVE -> expiresAtEpochMs <= nowEpochMs
    }
}
