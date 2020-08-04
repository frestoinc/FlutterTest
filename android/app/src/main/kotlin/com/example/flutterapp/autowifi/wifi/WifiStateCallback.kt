package com.example.flutterapp.autowifi.wifi

interface WifiStateCallback {
    fun onWifiStateEnabled()

    fun onSuccess(any: Any?)

    fun onFailed(errorCode: String, errorMessage: String?, errorDetails: Any?)
}