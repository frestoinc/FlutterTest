package com.example.flutterapp.autowifi.wifi

interface WifiNetworkCallback {
    fun onAvailable()

    fun onUnavailable()
}