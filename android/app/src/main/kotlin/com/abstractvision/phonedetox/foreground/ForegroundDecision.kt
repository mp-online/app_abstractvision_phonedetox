package com.abstractvision.phonedetox.foreground

import com.abstractvision.phonedetox.mindful.MindfulAdmissionSnapshot
import com.abstractvision.phonedetox.mindful.MindfulLaunchRequestSnapshot

sealed interface ForegroundDecision {
    data object Allow : ForegroundDecision
    data object ClearExpiredDetox : ForegroundDecision
    data object ClearAdmissionAndAllow : ForegroundDecision
    data class ActivateAdmissionAndAllow(
        val admission: MindfulAdmissionSnapshot,
    ) : ForegroundDecision
    data object ReturnHomeForDetox : ForegroundDecision
    data class ReturnHomeForMindfulOpening(val request: MindfulLaunchRequestSnapshot) : ForegroundDecision
}
