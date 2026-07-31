package com.abstractvision.phonedetox.detox

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.telecom.TelecomManager
import android.view.accessibility.AccessibilityEvent
import android.view.inputmethod.InputMethodManager

class PhoneDetoxAccessibilityService : AccessibilityService() {
    private lateinit var sessionStore: DetoxSessionStore
    private lateinit var decisionEngine: DetoxDecisionEngine
    private var lastPackageName: String? = null
    private var lastEventAtEpochMs: Long = 0

    override fun onServiceConnected() {
        super.onServiceConnected()
        sessionStore = DetoxSessionStore(this)
        decisionEngine = DetoxDecisionEngine(packageName)
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

        val decision = decisionEngine.evaluate(
            foregroundPackageName = foregroundPackage,
            session = sessionStore.read(),
            dynamicExemptPackages = dynamicExemptPackages(),
            nowEpochMs = now,
        )
        when (decision) {
            DetoxDecisionEngine.Decision.ALLOW -> Unit
            DetoxDecisionEngine.Decision.CLEAR_EXPIRED -> sessionStore.clear()
            DetoxDecisionEngine.Decision.BLOCK -> performGlobalAction(GLOBAL_ACTION_HOME)
        }
    }

    override fun onInterrupt() = Unit

    private fun dynamicExemptPackages(): Set<String> {
        val inputMethodManager =
            getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        val packages = inputMethodManager.enabledInputMethodList
            .map { it.packageName }
            .toMutableSet()
        val telecomManager = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
        telecomManager.defaultDialerPackage?.let(packages::add)
        return packages
    }

    companion object {
        private const val DEBOUNCE_MS = 500L
    }
}
