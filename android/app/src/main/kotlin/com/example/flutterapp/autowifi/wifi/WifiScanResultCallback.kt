package com.example.flutterapp.autowifi.wifi

import android.net.wifi.ScanResult

interface WifiScanResultCallback {
    fun onScanResult(list: List<ScanResult>)
}