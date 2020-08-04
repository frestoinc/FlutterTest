package com.example.flutterapp.autowifi

import com.example.flutterapp.autowifi.wifi.WifiNetworkCallback
import com.example.flutterapp.autowifi.wifi.WifiScanResultCallback
import com.example.flutterapp.autowifi.wifi.WifiStateCallback


interface ActivityCallback : WifiStateCallback,
        WifiNetworkCallback, WifiScanResultCallback