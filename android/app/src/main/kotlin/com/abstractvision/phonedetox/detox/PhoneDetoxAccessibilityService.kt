package com.abstractvision.phonedetox.detox

import android.accessibilityservice.AccessibilityService
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.PowerManager
import android.telecom.TelecomManager
import android.view.accessibility.AccessibilityEvent
import android.view.inputmethod.InputMethodManager
import com.abstractvision.phonedetox.foreground.CurrentHomeResolver
import com.abstractvision.phonedetox.foreground.ForegroundDecision
import com.abstractvision.phonedetox.foreground.ForegroundDecisionEngine
import com.abstractvision.phonedetox.foreground.ForegroundPackageClassifier
import com.abstractvision.phonedetox.mindful.MindfulAdmissionStore
import com.abstractvision.phonedetox.mindful.MindfulRequestStore
import com.abstractvision.phonedetox.mindful.MindfulRulesStore
import com.abstractvision.phonedetox.usage.AndroidUsageLimitClock
import com.abstractvision.phonedetox.usage.HandlerUsageLimitScheduler
import com.abstractvision.phonedetox.usage.UsageIntervalStore
import com.abstractvision.phonedetox.usage.UsageLimitReachedStore
import com.abstractvision.phonedetox.usage.UsageLimitRulesStore
import com.abstractvision.phonedetox.usage.UsageLimitRuntimeCoordinator
import com.abstractvision.phonedetox.usage.UsageLimitRuntimeRegistry

class PhoneDetoxAccessibilityService : AccessibilityService() {
    private lateinit var sessionStore: DetoxSessionStore
    private lateinit var mindfulRulesStore: MindfulRulesStore
    private lateinit var mindfulRequestStore: MindfulRequestStore
    private lateinit var mindfulAdmissionStore: MindfulAdmissionStore
    private lateinit var usageRulesStore: UsageLimitRulesStore
    private lateinit var usageIntervalStore: UsageIntervalStore
    private lateinit var usageReachedStore: UsageLimitReachedStore
    private lateinit var usageRuntime: UsageLimitRuntimeCoordinator
    private lateinit var decisionEngine: ForegroundDecisionEngine
    private lateinit var classifier: ForegroundPackageClassifier
    private lateinit var currentHomeResolver: CurrentHomeResolver
    private var lastPackageName: String? = null
    private var lastEventAtEpochMs: Long = 0
    private var screenReceiverRegistered = false

    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == Intent.ACTION_SCREEN_OFF && ::usageRuntime.isInitialized) {
                usageRuntime.pause()
            }
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        AccessibilityServiceInitializer.initialize(
            initializeSessionStore = { sessionStore = DetoxSessionStore(this) },
            initializeMindfulRulesStore = { mindfulRulesStore = MindfulRulesStore(this) },
            initializeMindfulRequestStore = { mindfulRequestStore = MindfulRequestStore(this) },
            initializeMindfulAdmissionStore = { mindfulAdmissionStore = MindfulAdmissionStore(this) },
            initializeUsageLimitDependencies = {
                usageRulesStore = UsageLimitRulesStore(this)
                usageIntervalStore = UsageIntervalStore(this)
                usageReachedStore = UsageLimitReachedStore(this)
            },
            initializeDecisionDependencies = {
                decisionEngine = ForegroundDecisionEngine(packageName)
                classifier = ForegroundPackageClassifier(packageName)
                currentHomeResolver = CurrentHomeResolver(this)
                usageRuntime = UsageLimitRuntimeCoordinator(
                    intervalStore = usageIntervalStore,
                    reachedStore = usageReachedStore,
                    clock = AndroidUsageLimitClock(),
                    scheduler = HandlerUsageLimitScheduler(),
                    currentForeground = { lastPackageName },
                    isInteractive = {
                        (getSystemService(Context.POWER_SERVICE) as PowerManager).isInteractive
                    },
                    isCurrentHome = currentHomeResolver::isCurrentHome,
                    activeDetoxPackages = {
                        sessionStore.getActive()?.blockedPackageNames ?: emptySet()
                    },
                    returnHome = { performGlobalAction(GLOBAL_ACTION_HOME) },
                )
                UsageLimitRuntimeRegistry.coordinator = usageRuntime
            },
            reconcileAfterInitialization = {
                sessionStore.getActive()
                mindfulRequestStore.clearExpired()
                mindfulAdmissionStore.clearExpired()
                usageRuntime.reconcileAfterServiceCreation()
            },
        )
        registerScreenReceiver()
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

        val dynamicSafe = dynamicSafePackages()
        if (classifier.isTransientOrCritical(foregroundPackage, dynamicSafe)) {
            when {
                foregroundPackage == packageName -> usageRuntime.leave()
                foregroundPackage == "com.android.settings" ||
                    foregroundPackage in admissionClearingPackages() -> usageRuntime.pause()
            }
        }

        val isCurrentHome = currentHomeResolver.isCurrentHome()
        if (!isCurrentHome) {
            mindfulRequestStore.clear()
            usageRuntime.clearAllEnforcement()
        }
        val session = sessionStore.read()
        val mindful = mindfulRulesStore.read()
        val pending = mindfulRequestStore.getActive(now)
        val admission = mindfulAdmissionStore.read()
        val decision = decisionEngine.evaluate(
            foregroundPackageName = foregroundPackage,
            session = session,
            mindful = mindful,
            pendingRequest = pending,
            admission = admission,
            isCurrentHome = isCurrentHome,
            dynamicSafePackages = dynamicSafe,
            admissionClearingPackages = admissionClearingPackages(),
            nowEpochMs = now,
        )

        when (decision) {
            ForegroundDecision.ReturnHomeForDetox -> {
                usageRuntime.clearRuntime()
                performGlobalAction(GLOBAL_ACTION_HOME)
                return
            }
            ForegroundDecision.ClearExpiredDetox -> sessionStore.clear()
            else -> Unit
        }

        val reached = usageReachedStore.read()
        if (isCurrentHome && reached?.packageName == foregroundPackage) {
            mindfulAdmissionStore.clear()
            usageRuntime.clearRuntime()
            performGlobalAction(GLOBAL_ACTION_HOME)
            return
        }

        when (decision) {
            ForegroundDecision.Allow,
            ForegroundDecision.ClearExpiredDetox -> applyUsage(foregroundPackage, isCurrentHome, pending != null)
            ForegroundDecision.ClearAdmissionAndAllow -> {
                mindfulAdmissionStore.clear()
                applyUsage(foregroundPackage, isCurrentHome, pending != null)
            }
            is ForegroundDecision.ActivateAdmissionAndAllow -> {
                mindfulAdmissionStore.save(decision.admission)
                applyUsage(foregroundPackage, isCurrentHome, false)
            }
            is ForegroundDecision.ReturnHomeForMindfulOpening -> {
                usageRuntime.leave()
                if (mindfulRequestStore.save(decision.request)) {
                    performGlobalAction(GLOBAL_ACTION_HOME)
                }
            }
            ForegroundDecision.ReturnHomeForDetox -> Unit
        }
    }

    override fun onInterrupt() = Unit

    override fun onDestroy() {
        if (screenReceiverRegistered) {
            unregisterReceiver(screenReceiver)
            screenReceiverRegistered = false
        }
        if (::usageRuntime.isInitialized) {
            usageRuntime.shutdown()
            if (UsageLimitRuntimeRegistry.coordinator === usageRuntime) {
                UsageLimitRuntimeRegistry.coordinator = null
            }
        }
        super.onDestroy()
    }

    private fun applyUsage(packageName: String, isCurrentHome: Boolean, hasPendingMindful: Boolean) {
        if (classifier.isTransientOrCritical(packageName, dynamicSafePackages())) return
        val rules = usageRulesStore.read()
        val rule = rules?.rules?.get(packageName)
        if (!isCurrentHome || rules?.enabled != true || hasPendingMindful || rule == null) {
            usageRuntime.leave()
            return
        }
        usageRuntime.enter(packageName, rule.limitMinutes * 60_000L)
    }

    private fun registerScreenReceiver() {
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_OFF)
            addAction(Intent.ACTION_SCREEN_ON)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(screenReceiver, filter, RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("DEPRECATION")
            registerReceiver(screenReceiver, filter)
        }
        screenReceiverRegistered = true
    }

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
