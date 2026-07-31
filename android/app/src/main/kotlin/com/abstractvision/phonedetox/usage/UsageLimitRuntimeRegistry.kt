package com.abstractvision.phonedetox.usage

object UsageLimitRuntimeRegistry {
    @Volatile var coordinator: UsageLimitRuntimeCoordinator? = null
}
