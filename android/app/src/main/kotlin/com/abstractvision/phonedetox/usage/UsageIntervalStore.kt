package com.abstractvision.phonedetox.usage

import android.content.Context

class UsageIntervalStore(context: Context) : UsageIntervalPersistence {
    private val preferences = context.getSharedPreferences(STORE_NAME, Context.MODE_PRIVATE)

    override fun save(value: UsageIntervalSnapshot): Boolean = preferences.edit()
        .putInt("schemaVersion", value.schemaVersion)
        .putString("packageName", value.packageName)
        .putLong("configuredLimitMs", value.configuredLimitMs)
        .putLong("remainingMs", value.remainingMs)
        .putString("phase", value.phase.wireValue)
        .putLong("startedAtEpochMs", value.startedAtEpochMs)
        .putLong("updatedAtEpochMs", value.updatedAtEpochMs)
        .commit()

    override fun read(): UsageIntervalSnapshot? = try {
        val packageName = preferences.getString("packageName", null) ?: return null
        UsageIntervalSnapshot(
            schemaVersion = preferences.getInt("schemaVersion", -1),
            packageName = packageName,
            configuredLimitMs = preferences.getLong("configuredLimitMs", -1),
            remainingMs = preferences.getLong("remainingMs", -1),
            phase = UsageIntervalPhase.fromWire(
                preferences.getString("phase", null) ?: "",
            ) ?: error("Unsupported phase"),
            startedAtEpochMs = preferences.getLong("startedAtEpochMs", -1),
            updatedAtEpochMs = preferences.getLong("updatedAtEpochMs", -1),
        )
    } catch (_: Exception) {
        clear()
        null
    }

    override fun clear(): Boolean = preferences.edit().clear().commit()

    companion object {
        private const val STORE_NAME = "phone_detox_native_usage_limit_interval"
    }
}
