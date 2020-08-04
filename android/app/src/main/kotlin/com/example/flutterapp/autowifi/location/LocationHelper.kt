package com.example.flutterapp.autowifi.location

interface LocationHelper {
    val requiredLocationPermissions: Array<String>
    val providerChangedIntentAction: String
    fun isLocationEnabled(): Boolean
    fun locationPermissionsGranted(): Boolean
}

