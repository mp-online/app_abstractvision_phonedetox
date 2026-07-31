package com.abstractvision.phonedetox.launcher

import android.content.Intent

interface HomeRoleGateway {
    fun getStatus(): HomeRoleStatus
    fun createRequestIntent(): Intent?
    fun openHomeSettings(): Boolean
}
