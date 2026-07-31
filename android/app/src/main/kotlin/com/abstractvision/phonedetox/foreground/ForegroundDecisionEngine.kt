package com.abstractvision.phonedetox.foreground

import com.abstractvision.phonedetox.detox.DetoxSessionSnapshot
import com.abstractvision.phonedetox.mindful.MindfulAdmissionPhase
import com.abstractvision.phonedetox.mindful.MindfulAdmissionSnapshot
import com.abstractvision.phonedetox.mindful.MindfulLaunchRequestSnapshot
import com.abstractvision.phonedetox.mindful.MindfulRulesSnapshot

class ForegroundDecisionEngine(private val ownPackageName: String) {
    private val classifier = ForegroundPackageClassifier(ownPackageName)

    fun evaluate(
        foregroundPackageName: String?,
        session: DetoxSessionSnapshot?,
        mindful: MindfulRulesSnapshot?,
        pendingRequest: MindfulLaunchRequestSnapshot?,
        admission: MindfulAdmissionSnapshot?,
        isCurrentHome: Boolean,
        dynamicSafePackages: Set<String> = emptySet(),
        admissionClearingPackages: Set<String> = emptySet(),
        nowEpochMs: Long = System.currentTimeMillis(),
    ): ForegroundDecision {
        if (foregroundPackageName.isNullOrBlank()) return ForegroundDecision.Allow
        if (classifier.isTransientOrCritical(foregroundPackageName, dynamicSafePackages)) {
            if (admission != null) {
                if (admission.isExpiredAt(nowEpochMs)) {
                    return ForegroundDecision.ClearAdmissionAndAllow
                }
                val clearsAdmission = foregroundPackageName in admissionClearingPackages ||
                    !classifier.preservesAdmission(foregroundPackageName, dynamicSafePackages)
                if (admission.phase == MindfulAdmissionPhase.ACTIVE && clearsAdmission) {
                    return ForegroundDecision.ClearAdmissionAndAllow
                }
                if (admission.phase == MindfulAdmissionPhase.AWAITING_TARGET &&
                    (foregroundPackageName == "com.android.settings" ||
                        foregroundPackageName in admissionClearingPackages)) {
                    return ForegroundDecision.ClearAdmissionAndAllow
                }
            }
            return ForegroundDecision.Allow
        }
        if (session != null && session.endsAtEpochMs <= nowEpochMs) {
            return ForegroundDecision.ClearExpiredDetox
        }
        if (session != null && foregroundPackageName in session.blockedPackageNames) {
            return ForegroundDecision.ReturnHomeForDetox
        }
        if (admission != null) {
            if (admission.isExpiredAt(nowEpochMs)) {
                return ForegroundDecision.ClearAdmissionAndAllow
            }
            return when (admission.phase) {
                MindfulAdmissionPhase.AWAITING_TARGET -> {
                    if (admission.packageName == foregroundPackageName) {
                        ForegroundDecision.ActivateAdmissionAndAllow(admission.activate())
                    } else {
                        ForegroundDecision.ClearAdmissionAndAllow
                    }
                }
                MindfulAdmissionPhase.ACTIVE -> {
                    if (admission.packageName == foregroundPackageName) {
                        ForegroundDecision.Allow
                    } else {
                        ForegroundDecision.ClearAdmissionAndAllow
                    }
                }
            }
        }
        if (!isCurrentHome || mindful?.enabled != true || mindful.disclosureVersion < 2) {
            return ForegroundDecision.Allow
        }
        val rule = mindful.rules[foregroundPackageName] ?: return ForegroundDecision.Allow
        if (pendingRequest != null && pendingRequest.expiresAtEpochMs > nowEpochMs) {
            return ForegroundDecision.Allow
        }
        return ForegroundDecision.ReturnHomeForMindfulOpening(
            MindfulLaunchRequestSnapshot.create(rule, "external", nowEpochMs),
        )
    }
}
