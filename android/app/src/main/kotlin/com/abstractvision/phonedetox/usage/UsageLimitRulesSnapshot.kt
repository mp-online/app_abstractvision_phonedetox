package com.abstractvision.phonedetox.usage

data class UsageLimitRulesSnapshot(
    val schemaVersion: Int,
    val enabled: Boolean,
    val disclosureVersion: Int,
    val rules: Map<String, UsageLimitRuleSnapshot>,
) {
    init {
        require(schemaVersion == SCHEMA_VERSION)
        require(!enabled || disclosureVersion >= REQUIRED_DISCLOSURE_VERSION)
        require(rules.size <= MAX_RULES)
        require(rules.keys.all { it == rules[it]?.packageName })
    }

    companion object {
        const val SCHEMA_VERSION = 1
        const val REQUIRED_DISCLOSURE_VERSION = 3
        const val MAX_RULES = 500
    }
}
