package com.abstractvision.phonedetox.mindful

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MindfulPlatformHandler(context: Context, messenger: BinaryMessenger) {
    private val rulesStore = MindfulRulesStore(context)
    private val requestStore = MindfulRequestStore(context)
    private val admissionStore = MindfulAdmissionStore(context)

    init {
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "synchronizeMindfulRules" -> { synchronize(call); result.success(null) }
                    "requestDirectMindfulLaunch" -> result.success(requestDirect(call)?.toMap())
                    "getPendingMindfulLaunch" -> result.success(requestStore.getActive()?.toMap())
                    "clearPendingMindfulLaunch" -> {
                        if (!requestStore.clear()) fail("request_persistence_failed", "Could not clear request")
                        result.success(null)
                    }
                    "grantMindfulAdmission" -> { grantAdmission(call); result.success(null) }
                    "clearMindfulAdmission" -> {
                        if (!admissionStore.clear()) fail("admission_persistence_failed", "Could not clear admission")
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (error: PlatformFailure) {
                result.error(error.code, error.message, null)
            } catch (error: Exception) {
                result.error("native_failure", error.message, null)
            }
        }
    }

    private fun synchronize(call: MethodCall) {
        val payload = call.arguments as? Map<*, *> ?: fail("invalid_arguments", "Missing snapshot")
        val schema = (payload["schemaVersion"] as? Number)?.toInt()
            ?: fail("invalid_arguments", "Missing schemaVersion")
        if (schema != 1) fail("unsupported_schema", "Unsupported schema")
        val requestedEnabled = payload["enabled"] as? Boolean ?: fail("invalid_arguments", "Missing enabled")
        val disclosure = (payload["disclosureVersion"] as? Number)?.toInt() ?: 0
        val rawRules = payload["rules"] as? List<*> ?: fail("invalid_arguments", "Missing rules")
        if (rawRules.size > 500) fail("invalid_arguments", "Too many rules")
        val rules = LinkedHashMap<String, MindfulRuleSnapshot>()
        rawRules.forEach { raw ->
            val item = raw as? Map<*, *> ?: fail("invalid_arguments", "Malformed rule")
            val packageName = (item["packageName"] as? String)?.takeIf { it.isNotBlank() }
                ?: fail("invalid_arguments", "Invalid package")
            val mode = MindfulMode.fromWire(item["mode"] as? String ?: "")
                ?: fail("invalid_arguments", "Unsupported mode")
            val delay = (item["delaySeconds"] as? Number)?.toInt()
                ?: fail("invalid_arguments", "Invalid delay")
            val rule = try { MindfulRuleSnapshot(packageName, mode, delay) }
            catch (_: IllegalArgumentException) { fail("invalid_arguments", "Invalid rule") }
            if (rules.put(packageName, rule) != null) fail("invalid_arguments", "Duplicate rule")
        }
        val snapshot = MindfulRulesSnapshot(schema, requestedEnabled && disclosure >= 2, disclosure, rules)
        if (!rulesStore.save(snapshot)) fail("rule_persistence_failed", "Could not persist rules")
        if (!requestedEnabled) { requestStore.clear(); admissionStore.clear() }
    }

    private fun requestDirect(call: MethodCall): MindfulLaunchRequestSnapshot? {
        val packageName = requiredPackage(call)
        requestStore.getActive()?.let { return it }
        admissionStore.getActive()?.let {
            if (it.packageName == packageName) return null
        }
        val rule = rulesStore.read()?.rules?.get(packageName) ?: return null
        val request = MindfulLaunchRequestSnapshot.create(rule, "launcher", System.currentTimeMillis())
        if (!requestStore.save(request)) fail("request_persistence_failed", "Could not persist request")
        return request
    }

    private fun grantAdmission(call: MethodCall) {
        val packageName = requiredPackage(call)
        val now = System.currentTimeMillis()
        if (!admissionStore.save(MindfulAdmissionSnapshot(
                packageName = packageName,
                phase = MindfulAdmissionPhase.AWAITING_TARGET,
                grantedAtEpochMs = now,
                targetDeadlineEpochMs = now + 15 * 1000L,
                expiresAtEpochMs = now + 12 * 60 * 60 * 1000L,
            ))) {
            fail("admission_persistence_failed", "Could not persist admission")
        }
    }

    private fun requiredPackage(call: MethodCall): String =
        call.argument<String>("packageName")?.takeIf { it.isNotBlank() }
            ?: fail("invalid_arguments", "Missing packageName")
    private fun fail(code: String, message: String): Nothing = throw PlatformFailure(code, message)
    private class PlatformFailure(val code: String, message: String) : IllegalStateException(message)
    companion object { private const val CHANNEL_NAME = "com.abstractvision.phonedetox/mindful" }
}
