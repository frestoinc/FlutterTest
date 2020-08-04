package com.example.flutterapp.autowifi.location

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager

class AutoWifiLocationHelper(private val appContext: Context) :
        LocationHelper {

    private val packageManager = appContext.packageManager
    private val packageName = appContext.packageName

    companion object {
        val requiredLocationPermissions = arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
        )
    }

    override val providerChangedIntentAction: String
        get() = LocationManager.PROVIDERS_CHANGED_ACTION

    override val requiredLocationPermissions: Array<String>
        get() = Companion.requiredLocationPermissions

    override fun isLocationEnabled(): Boolean {
        if (!locationPermissionsGranted()) return false
        val locationManager =
                appContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }

    override fun locationPermissionsGranted(): Boolean {
        return requiredLocationPermissions.all { permission ->
            packageManager.checkPermission(
                    permission,
                    packageName
            ) == PackageManager.PERMISSION_GRANTED
        }
    }

}