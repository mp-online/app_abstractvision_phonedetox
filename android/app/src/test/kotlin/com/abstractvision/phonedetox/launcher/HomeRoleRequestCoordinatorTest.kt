package com.abstractvision.phonedetox.launcher

import android.app.Activity
import android.content.Intent
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class HomeRoleRequestCoordinatorTest {
    @Test
    fun alreadyHeldCompletesImmediately() {
        val gateway = FakeGateway(currentStatus = HomeRoleStatus.HELD)
        val coordinator = HomeRoleRequestCoordinator(gateway) {}
        var result: Result<HomeRoleRequestResult>? = null

        coordinator.request { result = it }

        assertEquals(HomeRoleRequestResult.ALREADY_HELD, result?.getOrNull())
        assertFalse(coordinator.isRequestPending)
    }

    @Test
    fun unavailableOpensSettingsWhenPossible() {
        val gateway = FakeGateway(
            currentStatus = HomeRoleStatus.UNAVAILABLE,
            settingsAvailable = true,
        )
        val coordinator = HomeRoleRequestCoordinator(gateway) {}
        var result: Result<HomeRoleRequestResult>? = null

        coordinator.request { result = it }

        assertEquals(HomeRoleRequestResult.OPENED_SETTINGS, result?.getOrNull())
    }

    @Test
    fun unavailableWithoutSettingsReturnsUnavailable() {
        val gateway = FakeGateway(currentStatus = HomeRoleStatus.UNAVAILABLE)
        val coordinator = HomeRoleRequestCoordinator(gateway) {}
        var result: Result<HomeRoleRequestResult>? = null

        coordinator.request { result = it }

        assertEquals(HomeRoleRequestResult.UNAVAILABLE, result?.getOrNull())
    }

    @Test
    fun onlyOneRequestCanBePendingAndGrantRechecksStatus() {
        val gateway = FakeGateway(
            currentStatus = HomeRoleStatus.NOT_HELD,
            requestIntent = Intent(),
        )
        val coordinator = HomeRoleRequestCoordinator(gateway) {}
        var first: Result<HomeRoleRequestResult>? = null
        var second: Result<HomeRoleRequestResult>? = null

        coordinator.request { first = it }
        coordinator.request { second = it }
        assertTrue(coordinator.isRequestPending)
        assertTrue(second?.exceptionOrNull() is HomeRoleRequestCoordinator.RequestInProgressException)

        gateway.currentStatus = HomeRoleStatus.HELD
        coordinator.onActivityResult(Activity.RESULT_CANCELED)
        assertEquals(HomeRoleRequestResult.GRANTED, first?.getOrNull())
        assertFalse(coordinator.isRequestPending)
    }

    @Test
    fun cancelledAndDeniedAreDistinguishedWhenRoleIsNotHeld() {
        val gateway = FakeGateway(
            currentStatus = HomeRoleStatus.NOT_HELD,
            requestIntent = Intent(),
        )
        val coordinator = HomeRoleRequestCoordinator(gateway) {}
        var cancelled: Result<HomeRoleRequestResult>? = null
        coordinator.request { cancelled = it }
        coordinator.onActivityResult(Activity.RESULT_CANCELED)
        assertEquals(HomeRoleRequestResult.CANCELLED, cancelled?.getOrNull())

        var denied: Result<HomeRoleRequestResult>? = null
        coordinator.request { denied = it }
        coordinator.onActivityResult(Activity.RESULT_OK)
        assertEquals(HomeRoleRequestResult.DENIED, denied?.getOrNull())
    }

    private class FakeGateway(
        var currentStatus: HomeRoleStatus,
        private val requestIntent: Intent? = null,
        private val settingsAvailable: Boolean = false,
    ) : HomeRoleGateway {
        override fun getStatus(): HomeRoleStatus = currentStatus
        override fun createRequestIntent(): Intent? = requestIntent
        override fun openHomeSettings(): Boolean = settingsAvailable
    }
}
