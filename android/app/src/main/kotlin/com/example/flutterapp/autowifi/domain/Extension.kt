package com.example.flutterapp.autowifi.domain

import android.os.Build


const val REQUEST_CODE_FOR_SWITCH_ON_WIFI = 0x99

const val REQUEST_CODE_FOR_LOCATION_PERMISSION = 0x98

const val REQUEST_CODE_FOR_TURN_ON_LOCATION = 0x97

const val REQUEST_CODE_FOR_TURN_ON_BLUETOOTH = 0x96

fun isAndroidQorLater(): Boolean {
    return Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
}

fun isAndroidMarshmallowOrLater(): Boolean {
    return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
}

fun convertToQuotedString(ssid: String): String {
    if (ssid.isEmpty()) {
        return ""
    }
    val lastPos = ssid.length - 1
    return if (lastPos < 0 || ssid[0] == '"' && ssid[lastPos] == '"') {
        ssid
    } else "\"" + ssid + "\""
}