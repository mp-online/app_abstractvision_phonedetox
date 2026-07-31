package com.abstractvision.phonedetox.detox

import android.content.Context

class DetoxSessionStore(context: Context) {
    private val preferences = context.getSharedPreferences(STORE_NAME, Context.MODE_PRIVATE)

    fun save(snapshot: DetoxSessionSnapshot): Boolean = preferences.edit()
        .putString(KEY_ID, snapshot.id)
        .putLong(KEY_STARTED_AT, snapshot.startedAtEpochMs)
        .putLong(KEY_ENDS_AT, snapshot.endsAtEpochMs)
        .putStringSet(KEY_PACKAGES, snapshot.blockedPackageNames)
        .commit()

    fun read(): DetoxSessionSnapshot? {
        val id = preferences.getString(KEY_ID, null) ?: return null
        val startedAt = preferences.getLong(KEY_STARTED_AT, -1)
        val endsAt = preferences.getLong(KEY_ENDS_AT, -1)
        val packages = preferences.getStringSet(KEY_PACKAGES, null)?.toSet() ?: return null
        return try {
            DetoxSessionSnapshot(id, startedAt, endsAt, packages)
        } catch (_: Exception) {
            clear()
            null
        }
    }

    fun getActive(nowEpochMs: Long = System.currentTimeMillis()): DetoxSessionSnapshot? {
        val snapshot = read() ?: return null
        if (snapshot.endsAtEpochMs <= nowEpochMs) {
            clear()
            return null
        }
        return snapshot
    }

    fun clear(): Boolean = preferences.edit().clear().commit()

    companion object {
        private const val STORE_NAME = "phone_detox_native_session"
        private const val KEY_ID = "sessionId"
        private const val KEY_STARTED_AT = "startedAtEpochMs"
        private const val KEY_ENDS_AT = "endsAtEpochMs"
        private const val KEY_PACKAGES = "blockedPackageNames"
    }
}
