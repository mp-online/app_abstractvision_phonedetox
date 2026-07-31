package com.abstractvision.phonedetox.usage

enum class UsageIntervalPhase(val wireValue: String) {
    RUNNING("running"),
    PAUSED("paused");

    companion object {
        fun fromWire(value: String): UsageIntervalPhase? =
            entries.firstOrNull { it.wireValue == value }
    }
}
