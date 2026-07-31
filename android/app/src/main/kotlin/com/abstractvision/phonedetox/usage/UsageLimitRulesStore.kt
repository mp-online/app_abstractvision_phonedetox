package com.abstractvision.phonedetox.usage

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

class UsageLimitRulesStore(context: Context) {
    private val preferences = context.getSharedPreferences(STORE_NAME, Context.MODE_PRIVATE)

    fun save(snapshot: UsageLimitRulesSnapshot): Boolean {
        val rules = JSONArray()
        snapshot.rules.values.forEach { rule ->
            rules.put(JSONObject().apply {
                put("packageName", rule.packageName)
                put("limitMinutes", rule.limitMinutes)
            })
        }
        val json = JSONObject().apply {
            put("schemaVersion", snapshot.schemaVersion)
            put("enabled", snapshot.enabled)
            put("disclosureVersion", snapshot.disclosureVersion)
            put("rules", rules)
        }
        return preferences.edit().putString(KEY_SNAPSHOT, json.toString()).commit()
    }

    fun read(): UsageLimitRulesSnapshot? {
        val raw = preferences.getString(KEY_SNAPSHOT, null) ?: return null
        return try {
            val json = JSONObject(raw)
            val array = json.getJSONArray("rules")
            require(array.length() <= UsageLimitRulesSnapshot.MAX_RULES)
            val rules = LinkedHashMap<String, UsageLimitRuleSnapshot>()
            for (index in 0 until array.length()) {
                val item = array.getJSONObject(index)
                val rule = UsageLimitRuleSnapshot(
                    packageName = item.getString("packageName"),
                    limitMinutes = item.getInt("limitMinutes"),
                )
                require(rules.put(rule.packageName, rule) == null) { "Duplicate package" }
            }
            UsageLimitRulesSnapshot(
                schemaVersion = json.getInt("schemaVersion"),
                enabled = json.getBoolean("enabled"),
                disclosureVersion = json.getInt("disclosureVersion"),
                rules = rules.toMap(),
            )
        } catch (_: Exception) {
            clear()
            null
        }
    }

    fun clear(): Boolean = preferences.edit().clear().commit()

    companion object {
        private const val STORE_NAME = "phone_detox_native_usage_limit_rules"
        private const val KEY_SNAPSHOT = "snapshot"
    }
}
