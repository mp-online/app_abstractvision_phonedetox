package com.abstractvision.phonedetox.foreground

import com.abstractvision.phonedetox.detox.DetoxSessionSnapshot
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
            if (admission != null && (foregroundPackageName in admissionClearingPackages ||
                    !classifier.preservesAdmission(foregroundPackageName, dynamicSafePackages))) {
                return ForegroundDecision.ClearAdmissionAndAllow
            }
            return ForegroundDecision.Allow
        }
        if (session != null && session.endsAtEpochMs <= nowEpochMs) return ForegroundDecision.ClearExpiredDetox
        if (session != null && foregroundPackageName in session.blockedPackageNames) {
            return ForegroundDecision.ReturnHomeForDetox
        }
        if (admission != null) {
            if (admission.expiresAtEpochMs <= nowEpochMs) return ForegroundDecision.ClearAdmissionAndAllow
            if (admission.packageName == foregroundPackageName) return ForegroundDecision.Allow
            return ForegroundDecision.ClearAdmissionAndAllow
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
