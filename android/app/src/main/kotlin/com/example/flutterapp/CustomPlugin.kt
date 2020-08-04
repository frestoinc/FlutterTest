package com.example.flutterapp

import android.bluetooth.BluetoothAdapter
import android.content.Intent
import android.content.pm.PackageManager
import android.net.wifi.ScanResult
import android.os.Handler
import android.provider.Settings
import androidx.annotation.NonNull
import com.example.flutterapp.autowifi.ActivityCallback
import com.example.flutterapp.autowifi.domain.REQUEST_CODE_FOR_LOCATION_PERMISSION
import com.example.flutterapp.autowifi.domain.REQUEST_CODE_FOR_SWITCH_ON_WIFI
import com.example.flutterapp.autowifi.domain.REQUEST_CODE_FOR_TURN_ON_LOCATION
import com.example.flutterapp.autowifi.domain.isAndroidQorLater
import com.example.flutterapp.autowifi.location.AutoWifiLocationHelper
import com.example.flutterapp.autowifi.wifi.AutoWifiHelper
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class CustomPlugin : FlutterActivity(), ActivityCallback {

    companion object {
        private const val CHANNEL = "flutterapp/custom"

        private const val SCAN = "SCAN"

        private const val CONNECT = "CONNECT"

        private const val UNKNOWN = "UNKNOWN"
    }

    private lateinit var result: MethodChannel.Result

    private lateinit var locationHelper: AutoWifiLocationHelper
    private lateinit var wifiHelper: AutoWifiHelper

    private var type: String = UNKNOWN
    private var arguments: Any = Any()

    private var setup = false

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        locationHelper = AutoWifiLocationHelper(this)
        wifiHelper = AutoWifiHelper(this, this)

        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, post ->
            result = post
            when (call.method) {
                "bluetoothSwitch" -> turnOnBluetooth()
                "locationSwitch" -> turnOnLocation()
                "autoWifiScan" -> {
                    type = SCAN
                    startAutoWifi()
                }
                "autoWifiConnect" -> {
                    type = CONNECT
                    arguments = call.arguments
                    startAutoWifi()
                }
            }
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        if (requestCode == REQUEST_CODE_FOR_LOCATION_PERMISSION) {
            if (grantResults.contains(PackageManager.PERMISSION_DENIED)) onFailed("LocationException", "locationPermission not granted", "") else turnOnLocation()
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_CODE_FOR_TURN_ON_LOCATION -> parseLocationResult()
            REQUEST_CODE_FOR_SWITCH_ON_WIFI -> parseWifiResult()
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onDestroy() {
        wifiHelper.unregisterNetworkReceiver()
        super.onDestroy()
    }

    private fun turnOnBluetooth() {
        try {
            val adapter = BluetoothAdapter.getDefaultAdapter()
            adapter.enable()
            onSuccess(true)
        } catch (e: Exception) {
            result.notImplemented()
        }
    }

    private fun turnOnLocation() {
        if (locationHelper.locationPermissionsGranted()) {
            val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
            startActivityForResult(
                    intent,
                    REQUEST_CODE_FOR_TURN_ON_LOCATION
            )
        } else {
            requestPermissions(locationHelper.requiredLocationPermissions, REQUEST_CODE_FOR_LOCATION_PERMISSION)
        }
    }

    private fun parseLocationResult() {
        if (locationHelper.isLocationEnabled()) {
            when (type) {
                UNKNOWN -> onSuccess(true)
                SCAN, CONNECT -> startAutoWifi()
            }
            return
        }
        onFailed("LocationException", "location service disabled", "")
    }

    private fun turnOnWifi() {
        if (isAndroidQorLater()) {
            val panelIntent = Intent(Settings.Panel.ACTION_WIFI)
            startActivityForResult(
                    panelIntent,
                    REQUEST_CODE_FOR_SWITCH_ON_WIFI
            )
        } else {
            wifiHelper.turnOnWifi()
            Handler().postDelayed({
                parseWifiResult()
            }, 1500)

        }
    }

    private fun parseWifiResult() {
        if (wifiHelper.isWifiEnabled()) {
            startAutoWifi()
        } else {
            onFailed("WifiException", "wifi service disabled", "")
        }
    }

    private fun startAutoWifi() {
        if (!wifiHelper.isWifiEnabled()) {
            turnOnWifi()
            return
        }

        if (!locationHelper.isLocationEnabled()) {
            turnOnLocation()
            return
        }

        resetNetworkReceiver()
    }

    private fun resetNetworkReceiver() {
        wifiHelper.unregisterNetworkReceiver()
        wifiHelper.registerNetworkReceiver()
    }

    override fun onSuccess(any: Any?) {
        result.success(any)
    }

    override fun onFailed(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        result.error(errorCode, errorMessage, errorDetails)
    }

    override fun onWifiStateEnabled() {
        when (type) {
            SCAN -> wifiHelper.startScan()
            CONNECT -> {
                val map = arguments as HashMap<*, *>
                if (wifiHelper.doesSSIDMatch(map["SSID"] as String)) {
                    onSuccess(true)
                } else {
                    wifiHelper.startScan()
                }
            }
        }
    }

    override fun onAvailable() {
        println("onAvailable")
        val map = arguments as HashMap<*, *>
        if (wifiHelper.doesSSIDMatch(map["SSID"] as String)) {
            runOnUiThread { onSuccess(true) }
        }
    }

    override fun onUnavailable() {
        runOnUiThread { onFailed("WifiException", "auto-wifi operation cancelled", "") }
    }

    override fun onScanResult(list: List<ScanResult>) {
        wifiHelper.stopScan()
        when (type) {
            SCAN -> onSuccess(Gson().toJson(list))
            CONNECT -> {
                setup = true
                val map = arguments as HashMap<*, *>
                val (match, _) = list.partition { it.SSID == map["SSID"] as String? }
                if (match.isEmpty()) {
                    onFailed("WifiException", "ssid not in range", "")
                } else {
                    wifiHelper.buildAutoWifiConnection(match.first(), map["pwd"] as String?)
                }
            }
        }

    }
}
