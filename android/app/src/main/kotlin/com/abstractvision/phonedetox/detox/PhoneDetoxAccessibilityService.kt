package com.abstractvision.phonedetox.detox

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.telecom.TelecomManager
import android.view.accessibility.AccessibilityEvent
import android.view.inputmethod.InputMethodManager
import com.abstractvision.phonedetox.foreground.CurrentHomeResolver
import com.abstractvision.phonedetox.foreground.ForegroundDecision
import com.abstractvision.phonedetox.foreground.ForegroundDecisionEngine
import com.abstractvision.phonedetox.mindful.MindfulAdmissionStore
import com.abstractvision.phonedetox.mindful.MindfulRequestStore
import com.abstractvision.phonedetox.mindful.MindfulRulesStore

class PhoneDetoxAccessibilityService : AccessibilityService() {
    private lateinit var sessionStore: DetoxSessionStore
    private lateinit var mindfulRulesStore: MindfulRulesStore
    private lateinit var mindfulRequestStore: MindfulRequestStore
    private lateinit var mindfulAdmissionStore: MindfulAdmissionStore
    private lateinit var decisionEngine: ForegroundDecisionEngine
    private lateinit var currentHomeResolver: CurrentHomeResolver
    private var lastPackageName: String? = null
    private var lastEventAtEpochMs: Long = 0

    override fun onServiceConnected() {
        super.onServiceConnected()
        AccessibilityServiceInitializer.initialize(
            initializeSessionStore = { sessionStore = DetoxSessionStore(this) },
            initializeMindfulRulesStore = { mindfulRulesStore = MindfulRulesStore(this) },
            initializeMindfulRequestStore = { mindfulRequestStore = MindfulRequestStore(this) },
            initializeMindfulAdmissionStore = { mindfulAdmissionStore = MindfulAdmissionStore(this) },
            initializeDecisionDependencies = {
                decisionEngine = ForegroundDecisionEngine(packageName)
                currentHomeResolver = CurrentHomeResolver(this)
            },
            reconcileAfterInitialization = {
                // Android owns service recreation; expired snapshots are read only after initialization.
                sessionStore.getActive()
                mindfulRequestStore.clearExpired()
                mindfulAdmissionStore.clearExpired()
            },
        )
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null ||
            (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED &&
                event.eventType != AccessibilityEvent.TYPE_WINDOWS_CHANGED)
        ) return
        val foregroundPackage = event.packageName?.toString()?.takeIf { it.isNotBlank() } ?: return
        val now = System.currentTimeMillis()
        if (foregroundPackage == lastPackageName && now - lastEventAtEpochMs < DEBOUNCE_MS) return
        lastPackageName = foregroundPackage
        lastEventAtEpochMs = now

        val isCurrentHome = currentHomeResolver.isCurrentHome()
        if (!isCurrentHome) mindfulRequestStore.clear()
        when (val decision = decisionEngine.evaluate(
            foregroundPackageName = foregroundPackage,
            session = sessionStore.read(),
            mindful = mindfulRulesStore.read(),
            pendingRequest = mindfulRequestStore.getActive(now),
            admission = mindfulAdmissionStore.getActive(now),
            isCurrentHome = isCurrentHome,
            dynamicSafePackages = dynamicSafePackages(),
            admissionClearingPackages = admissionClearingPackages(),
            nowEpochMs = now,
        )) {
            ForegroundDecision.Allow -> Unit
            ForegroundDecision.ClearExpiredDetox -> sessionStore.clear()
            ForegroundDecision.ClearAdmissionAndAllow -> mindfulAdmissionStore.clear()
            ForegroundDecision.ReturnHomeForDetox -> performGlobalAction(GLOBAL_ACTION_HOME)
            is ForegroundDecision.ReturnHomeForMindfulOpening -> {
                // Persist first: failure must leave the target app usable.
                if (mindfulRequestStore.save(decision.request)) {
                    performGlobalAction(GLOBAL_ACTION_HOME)
                }
            }
        }
    }

    override fun onInterrupt() = Unit

    private fun dynamicSafePackages(): Set<String> {
        val inputMethodManager = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        val packages = inputMethodManager.enabledInputMethodList.map { it.packageName }.toMutableSet()
        packages.addAll(admissionClearingPackages())
        return packages
    }

    private fun admissionClearingPackages(): Set<String> {
        val telecomManager = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
        return setOfNotNull(telecomManager.defaultDialerPackage)
    }

    companion object { private const val DEBOUNCE_MS = 500L }
}
