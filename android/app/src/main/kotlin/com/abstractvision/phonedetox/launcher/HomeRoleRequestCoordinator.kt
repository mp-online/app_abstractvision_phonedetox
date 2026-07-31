package com.abstractvision.phonedetox.launcher

import android.app.Activity
import android.content.Intent

class HomeRoleRequestCoordinator(
    private val gateway: HomeRoleGateway,
    private val launchRequest: (Intent) -> Unit,
) {
    private var pending: ((Result<HomeRoleRequestResult>) -> Unit)? = null

    val isRequestPending: Boolean get() = pending != null

    fun request(callback: (Result<HomeRoleRequestResult>) -> Unit) {
        if (pending != null) {
            callback(Result.failure(RequestInProgressException()))
            return
        }
        when (gateway.getStatus()) {
            HomeRoleStatus.HELD -> callback(Result.success(HomeRoleRequestResult.ALREADY_HELD))
            HomeRoleStatus.UNAVAILABLE -> {
                val opened = gateway.openHomeSettings()
                callback(
                    Result.success(
                        if (opened) HomeRoleRequestResult.OPENED_SETTINGS
                        else HomeRoleRequestResult.UNAVAILABLE,
                    ),
                )
            }
            HomeRoleStatus.NOT_HELD -> {
                val intent = gateway.createRequestIntent()
                if (intent == null) {
                    val opened = gateway.openHomeSettings()
                    callback(
                        Result.success(
                            if (opened) HomeRoleRequestResult.OPENED_SETTINGS
                            else HomeRoleRequestResult.UNAVAILABLE,
                        ),
                    )
                    return
                }
                pending = callback
                try {
                    launchRequest(intent)
                } catch (error: Exception) {
                    complete(Result.failure(error))
                }
            }
        }
    }

    fun onActivityResult(resultCode: Int) {
        if (pending == null) return
        val result = when {
            gateway.getStatus() == HomeRoleStatus.HELD -> HomeRoleRequestResult.GRANTED
            resultCode == Activity.RESULT_CANCELED -> HomeRoleRequestResult.CANCELLED
            else -> HomeRoleRequestResult.DENIED
        }
        complete(Result.success(result))
    }

    fun close() {
        if (pending != null) {
            complete(Result.failure(IllegalStateException("Activity destroyed during Home-role request.")))
        }
    }

    private fun complete(result: Result<HomeRoleRequestResult>) {
        val callback = pending ?: return
        pending = null
        callback(result)
    }

    class RequestInProgressException : IllegalStateException("A Home-role request is already active.")
}
