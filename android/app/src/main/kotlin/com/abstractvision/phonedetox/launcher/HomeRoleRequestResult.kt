package com.abstractvision.phonedetox.launcher

enum class HomeRoleRequestResult(val wireValue: String) {
    GRANTED("granted"),
    DENIED("denied"),
    CANCELLED("cancelled"),
    ALREADY_HELD("alreadyHeld"),
    OPENED_SETTINGS("openedSettings"),
    UNAVAILABLE("unavailable"),
}
