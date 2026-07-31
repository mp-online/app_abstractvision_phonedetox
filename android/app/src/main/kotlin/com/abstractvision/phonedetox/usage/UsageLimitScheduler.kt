package com.abstractvision.phonedetox.usage

interface UsageLimitScheduler {
    fun schedule(delayMs: Long, action: () -> Unit)
    fun cancel()
}
