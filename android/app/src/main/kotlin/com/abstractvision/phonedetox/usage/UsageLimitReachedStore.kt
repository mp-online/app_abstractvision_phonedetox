package com.abstractvision.phonedetox.usage

import android.content.Context

class UsageLimitReachedStore(context: Context) : UsageLimitReachedPersistence {
    private val preferences = context.getSharedPreferences(STORE_NAME, Context.MODE_PRIVATE)

    override fun save(value: UsageLimitReachedSnapshot): Boolean = preferences.edit()
        .putInt("schemaVersion", value.schemaVersion)
        .putString("packageName", value.packageName)
        .putLong("configuredLimitMs", value.configuredLimitMs)
        .putLong("reachedAtEpochMs", value.reachedAtEpochMs)
        .commit()

    override fun read(): UsageLimitReachedSnapshot? = try {
        val packageName = preferences.getString("packageName", null) ?: return null
        UsageLimitReachedSnapshot(
            schemaVersion = preferences.getInt("schemaVersion", -1),
            packageName = packageName,
            configuredLimitMs = preferences.getLong("configuredLimitMs", -1),
            reachedAtEpochMs = preferences.getLong("reachedAtEpochMs", -1),
        )
    } catch (_: Exception) {
        clear()
        null
    }

    override fun clear(): Boolean = preferences.edit().clear().commit()

    companion object {
        private const val STORE_NAME = "phone_detox_native_usage_limit_reached"
    }
}
