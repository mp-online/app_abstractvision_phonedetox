package com.abstractvision.phonedetox.usage

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UsageLimitPlatformHandler(context: Context, messenger: BinaryMessenger) {
    private val rulesStore = UsageLimitRulesStore(context)
    private val intervalStore = UsageIntervalStore(context)
    private val reachedStore = UsageLimitReachedStore(context)

    init {
        MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "synchronizeUsageLimitRules" -> { synchronize(call); result.success(null) }
                    "getUsageLimitRuntime" -> result.success(intervalStore.read()?.toMap())
                    "getUsageLimitReached" -> result.success(reachedStore.read()?.toMap())
                    "clearUsageLimitReached" -> {
                        persist(reachedStore.clear(), "reached_persistence_failed"); result.success(null)
                    }
                    "continueUsageLimit" -> {
                        val packageName = requiredPackage(call)
                        if (reachedStore.read()?.packageName != packageName) {
                            fail("limit_not_reached", "The usage limit is not reached for this app")
                        }
                        UsageLimitRuntimeRegistry.coordinator?.clearRuntime() ?: intervalStore.clear()
                        persist(reachedStore.clear(), "reached_persistence_failed")
                        result.success(null)
                    }
                    "restoreUsageLimitReached" -> {
                        persist(reachedStore.save(reachedFrom(call.arguments)), "reached_persistence_failed")
                        result.success(null)
                    }
                    "clearUsageLimitRuntime" -> {
                        UsageLimitRuntimeRegistry.coordinator?.clearRuntime() ?: intervalStore.clear()
                        result.success(null)
                    }
                    "clearAllUsageLimitEnforcement" -> {
                        UsageLimitRuntimeRegistry.coordinator?.clearAllEnforcement() ?: run {
                            intervalStore.clear(); reachedStore.clear()
                        }
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
        if (schema != UsageLimitRulesSnapshot.SCHEMA_VERSION) fail("unsupported_schema", "Unsupported schema")
        val enabled = payload["enabled"] as? Boolean ?: fail("invalid_arguments", "Missing enabled")
        val disclosure = (payload["disclosureVersion"] as? Number)?.toInt() ?: 0
        if (enabled && disclosure < UsageLimitRulesSnapshot.REQUIRED_DISCLOSURE_VERSION) {
            fail("disclosure_required", "Usage Limits require disclosure version 3")
        }
        val rawRules = payload["rules"] as? List<*> ?: fail("invalid_arguments", "Missing rules")
        if (rawRules.size > UsageLimitRulesSnapshot.MAX_RULES) fail("invalid_arguments", "Too many rules")
        val rules = LinkedHashMap<String, UsageLimitRuleSnapshot>()
        rawRules.forEach { raw ->
            val item = raw as? Map<*, *> ?: fail("invalid_arguments", "Malformed rule")
            val packageName = (item["packageName"] as? String)?.takeIf { it.isNotBlank() }
                ?: fail("invalid_arguments", "Invalid package")
            val minutes = (item["limitMinutes"] as? Number)?.toInt()
                ?: fail("invalid_arguments", "Invalid limit")
            val rule = try { UsageLimitRuleSnapshot(packageName, minutes) }
            catch (_: IllegalArgumentException) { fail("invalid_arguments", "Invalid rule") }
            if (rules.put(packageName, rule) != null) fail("invalid_arguments", "Duplicate rule")
        }
        persist(
            rulesStore.save(UsageLimitRulesSnapshot(schema, enabled, disclosure, rules)),
            "rule_persistence_failed",
        )
        val runtimePackage = intervalStore.read()?.packageName
        val reachedPackage = reachedStore.read()?.packageName
        if (!enabled || runtimePackage !in rules) {
            UsageLimitRuntimeRegistry.coordinator?.clearRuntime() ?: intervalStore.clear()
        }
        if (!enabled || reachedPackage !in rules) reachedStore.clear()
    }

    private fun reachedFrom(value: Any?): UsageLimitReachedSnapshot {
        val payload = value as? Map<*, *> ?: fail("invalid_arguments", "Missing reached limit")
        return try {
            UsageLimitReachedSnapshot(
                schemaVersion = (payload["schemaVersion"] as? Number)?.toInt() ?: 1,
                packageName = payload["packageName"] as? String ?: "",
                configuredLimitMs = (payload["configuredLimitMs"] as? Number)?.toLong() ?: -1,
                reachedAtEpochMs = (payload["reachedAtEpochMs"] as? Number)?.toLong() ?: -1,
            )
        } catch (_: IllegalArgumentException) {
            fail("invalid_arguments", "Invalid reached limit")
        }
    }

    private fun requiredPackage(call: MethodCall): String =
        call.argument<String>("packageName")?.takeIf { it.isNotBlank() }
            ?: fail("invalid_arguments", "Missing packageName")
    private fun persist(success: Boolean, code: String) {
        if (!success) fail(code, "Could not persist usage-limit state")
    }
    private fun fail(code: String, message: String): Nothing = throw PlatformFailure(code, message)
    private class PlatformFailure(val code: String, message: String) : IllegalStateException(message)
    companion object { private const val CHANNEL_NAME = "com.abstractvision.phonedetox/usage_limit" }
}
