package com.abstractvision.phonedetox.usage

interface UsageIntervalPersistence {
    fun save(value: UsageIntervalSnapshot): Boolean
    fun read(): UsageIntervalSnapshot?
    fun clear(): Boolean
}
