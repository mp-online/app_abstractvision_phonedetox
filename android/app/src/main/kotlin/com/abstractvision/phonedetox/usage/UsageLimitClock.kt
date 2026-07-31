package com.abstractvision.phonedetox.usage

interface UsageLimitClock {
    fun wallTimeMillis(): Long
    fun elapsedRealtimeMillis(): Long
}
