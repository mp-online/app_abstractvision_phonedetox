package com.abstractvision.phonedetox.usage

import android.os.SystemClock

class AndroidUsageLimitClock : UsageLimitClock {
    override fun wallTimeMillis(): Long = System.currentTimeMillis()
    override fun elapsedRealtimeMillis(): Long = SystemClock.elapsedRealtime()
}
