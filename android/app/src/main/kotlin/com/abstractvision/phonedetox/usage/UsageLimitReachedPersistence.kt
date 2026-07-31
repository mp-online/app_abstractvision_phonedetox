package com.abstractvision.phonedetox.usage

interface UsageLimitReachedPersistence {
    fun save(value: UsageLimitReachedSnapshot): Boolean
    fun read(): UsageLimitReachedSnapshot?
    fun clear(): Boolean
}
