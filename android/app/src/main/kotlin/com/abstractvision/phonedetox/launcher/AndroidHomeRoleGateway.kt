package com.abstractvision.phonedetox.launcher

import android.app.Activity
import android.app.role.RoleManager
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings

class AndroidHomeRoleGateway(private val activity: Activity) : HomeRoleGateway {
    override fun getStatus(): HomeRoleStatus {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = activity.getSystemService(RoleManager::class.java)
            if (!roleManager.isRoleAvailable(RoleManager.ROLE_HOME)) {
                return HomeRoleStatus.UNAVAILABLE
            }
            return if (roleManager.isRoleHeld(RoleManager.ROLE_HOME)) {
                HomeRoleStatus.HELD
            } else {
                HomeRoleStatus.NOT_HELD
            }
        }
        val homeIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        val resolved = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.packageManager.resolveActivity(
                homeIntent,
                PackageManager.ResolveInfoFlags.of(
                    PackageManager.MATCH_DEFAULT_ONLY.toLong(),
                ),
            )
        } else {
            @Suppress("DEPRECATION")
            activity.packageManager.resolveActivity(
                homeIntent,
                PackageManager.MATCH_DEFAULT_ONLY,
            )
        }
        return if (resolved?.activityInfo?.packageName == activity.packageName) {
            HomeRoleStatus.HELD
        } else {
            HomeRoleStatus.NOT_HELD
        }
    }

    override fun createRequestIntent(): Intent? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return null
        val roleManager = activity.getSystemService(RoleManager::class.java)
        return if (roleManager.isRoleAvailable(RoleManager.ROLE_HOME)) {
            roleManager.createRequestRoleIntent(RoleManager.ROLE_HOME)
        } else {
            null
        }
    }

    override fun openHomeSettings(): Boolean {
        val intents = listOf(
            Intent(Settings.ACTION_HOME_SETTINGS),
            Intent(Settings.ACTION_MANAGE_DEFAULT_APPS_SETTINGS),
            Intent(Settings.ACTION_SETTINGS),
        )
        val intent = intents.firstOrNull { it.resolveActivity(activity.packageManager) != null }
            ?: return false
        activity.startActivity(intent)
        return true
    }
}
