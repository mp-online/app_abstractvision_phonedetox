package com.abstractvision.phonedetox.mindful

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

class MindfulRulesStore(context: Context) {
    private val preferences = context.getSharedPreferences(STORE_NAME, Context.MODE_PRIVATE)

    fun save(snapshot: MindfulRulesSnapshot): Boolean {
        val rules = JSONArray()
        snapshot.rules.values.forEach { rule ->
            rules.put(JSONObject().apply {
                put("packageName", rule.packageName)
                put("mode", rule.mode.wireValue)
                put("delaySeconds", rule.delaySeconds)
            })
        }
        return preferences.edit().putString(KEY_SNAPSHOT, JSONObject().apply {
            put("schemaVersion", snapshot.schemaVersion)
            put("enabled", snapshot.enabled)
            put("disclosureVersion", snapshot.disclosureVersion)
            put("rules", rules)
        }.toString()).commit()
    }

    fun read(): MindfulRulesSnapshot? {
        val raw = preferences.getString(KEY_SNAPSHOT, null) ?: return null
        return try {
            val json = JSONObject(raw)
            val array = json.getJSONArray("rules")
            require(array.length() <= 500)
            val rules = LinkedHashMap<String, MindfulRuleSnapshot>()
            for (index in 0 until array.length()) {
                val item = array.getJSONObject(index)
                val packageName = item.getString("packageName")
                val rule = MindfulRuleSnapshot(
                    packageName,
                    MindfulMode.fromWire(item.getString("mode")) ?: error("Unsupported mode"),
                    item.getInt("delaySeconds"),
                )
                require(rules.put(packageName, rule) == null) { "Duplicate package" }
            }
            MindfulRulesSnapshot(
                json.getInt("schemaVersion"),
                json.getBoolean("enabled"),
                json.getInt("disclosureVersion"),
                rules.toMap(),
            )
        } catch (_: Exception) {
            clear()
            null
        }
    }

    fun clear(): Boolean = preferences.edit().clear().commit()

    companion object {
        private const val STORE_NAME = "phone_detox_native_mindful_rules"
        private const val KEY_SNAPSHOT = "snapshot"
    }
}

class MindfulRequestStore(context: Context) {
    private val preferences = context.getSharedPreferences(STORE_NAME, Context.MODE_PRIVATE)

    fun save(value: MindfulLaunchRequestSnapshot): Boolean = preferences.edit()
        .putString("requestId", value.requestId).putString("packageName", value.packageName)
        .putString("source", value.source).putString("mode", value.mode.wireValue)
        .putLong("createdAtEpochMs", value.createdAtEpochMs)
        .putLong("availableAtEpochMs", value.availableAtEpochMs)
        .putLong("expiresAtEpochMs", value.expiresAtEpochMs).commit()

    fun read(): MindfulLaunchRequestSnapshot? = try {
        val id = preferences.getString("requestId", null) ?: return null
        MindfulLaunchRequestSnapshot(
            id, preferences.getString("packageName", null) ?: error("package"),
            preferences.getString("source", null) ?: error("source"),
            MindfulMode.fromWire(preferences.getString("mode", null) ?: "") ?: error("mode"),
            preferences.getLong("createdAtEpochMs", -1),
            preferences.getLong("availableAtEpochMs", -1),
            preferences.getLong("expiresAtEpochMs", -1),
        )
    } catch (_: Exception) { clear(); null }

    fun getActive(nowEpochMs: Long = System.currentTimeMillis()): MindfulLaunchRequestSnapshot? {
        val value = read() ?: return null
        if (value.expiresAtEpochMs <= nowEpochMs) { clear(); return null }
        return value
    }
    fun clearExpired(nowEpochMs: Long = System.currentTimeMillis()) { getActive(nowEpochMs) }
    fun clear(): Boolean = preferences.edit().clear().commit()

    companion object { private const val STORE_NAME = "phone_detox_native_mindful_request" }
}

class MindfulAdmissionStore(context: Context) {
    private val preferences = context.getSharedPreferences(STORE_NAME, Context.MODE_PRIVATE)
    fun save(value: MindfulAdmissionSnapshot): Boolean = preferences.edit()
        .putInt("schemaVersion", SCHEMA_VERSION)
        .putString("packageName", value.packageName)
        .putString("phase", value.phase.wireValue)
        .putLong("grantedAtEpochMs", value.grantedAtEpochMs)
        .putLong("targetDeadlineEpochMs", value.targetDeadlineEpochMs)
        .putLong("expiresAtEpochMs", value.expiresAtEpochMs).commit()
    fun read(): MindfulAdmissionSnapshot? = try {
        val packageName = preferences.getString("packageName", null) ?: return null
        decode(
            schemaVersion = preferences.getInt("schemaVersion", -1),
            packageName = packageName,
            phase = preferences.getString("phase", null),
            grantedAtEpochMs = preferences.getLong("grantedAtEpochMs", -1),
            targetDeadlineEpochMs = preferences.getLong("targetDeadlineEpochMs", -1),
            expiresAtEpochMs = preferences.getLong("expiresAtEpochMs", -1),
        ) ?: run { clear(); null }
    } catch (_: Exception) { clear(); null }
    fun getActive(nowEpochMs: Long = System.currentTimeMillis()): MindfulAdmissionSnapshot? {
        val value = read() ?: return null
        if (value.isExpiredAt(nowEpochMs)) { clear(); return null }
        return value
    }
    fun clearExpired(nowEpochMs: Long = System.currentTimeMillis()) { getActive(nowEpochMs) }
    fun clear(): Boolean = preferences.edit().clear().commit()
    companion object {
        const val SCHEMA_VERSION = 2
        private const val STORE_NAME = "phone_detox_native_mindful_admission"

        internal fun decode(
            schemaVersion: Int,
            packageName: String?,
            phase: String?,
            grantedAtEpochMs: Long,
            targetDeadlineEpochMs: Long,
            expiresAtEpochMs: Long,
        ): MindfulAdmissionSnapshot? = try {
            if (schemaVersion != SCHEMA_VERSION) return null
            MindfulAdmissionSnapshot(
                packageName = packageName?.takeIf { it.isNotBlank() } ?: return null,
                phase = MindfulAdmissionPhase.fromWire(phase ?: "") ?: return null,
                grantedAtEpochMs = grantedAtEpochMs,
                targetDeadlineEpochMs = targetDeadlineEpochMs,
                expiresAtEpochMs = expiresAtEpochMs,
            )
        } catch (_: IllegalArgumentException) {
            null
        }
    }
}
