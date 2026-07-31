package com.abstractvision.phonedetox.usage

import android.os.Handler
import android.os.Looper

class HandlerUsageLimitScheduler : UsageLimitScheduler {
    private val handler = Handler(Looper.getMainLooper())
    private var pending: Runnable? = null

    override fun schedule(delayMs: Long, action: () -> Unit) {
        cancel()
        val runnable = Runnable(action)
        pending = runnable
        handler.postDelayed(runnable, delayMs)
    }

    override fun cancel() {
        pending?.let(handler::removeCallbacks)
        pending = null
    }
}
