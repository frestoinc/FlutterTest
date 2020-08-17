package com.example.flutterapp.autowifi.wifi

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.*
import android.net.wifi.*
import android.os.Build
import android.os.Handler
import android.os.PatternMatcher
import android.util.Log
import androidx.annotation.RequiresApi
import com.example.flutterapp.autowifi.ActivityCallback
import com.example.flutterapp.autowifi.domain.convertToQuotedString
import com.example.flutterapp.autowifi.domain.isAndroidMarshmallowOrLater
import com.example.flutterapp.autowifi.domain.isAndroidQorLater
import java.util.*

class AutoWifiHelper(private val appContext: Context, private val activityCallback: ActivityCallback) : WifiHelper {
    companion object {
        private const val WIFI_SCAN_RECEIVER = "WIFI_SCAN_RECEIVER"
        private const val WIFI_STATE_RECEIVER = "WIFI_STATE_RECEIVER"
        private const val WIFI_NETWORK_CALLBACK = "WIFI_NETWORK_CALLBACK"
    }

    private val wifiManager =
            appContext.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager

    private val connectivityManager =
            appContext.applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

    private var map = mutableMapOf(WIFI_SCAN_RECEIVER to false, WIFI_STATE_RECEIVER to false, WIFI_NETWORK_CALLBACK to false)

    private val wifiScanReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {
            if (intent.action == WifiManager.SCAN_RESULTS_AVAILABLE_ACTION) {
                Handler().postDelayed({
                    activityCallback.onScanResult(wifiManager.scanResults)
                }, 2000)
            }
        }
    }

    private val wifiStateReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            Log.e("TAG", "action:${intent.action}")
            when (intent.action) {
                WifiManager.WIFI_STATE_CHANGED_ACTION -> {
                    when (intent.getIntExtra(
                            WifiManager.EXTRA_WIFI_STATE,
                            WifiManager.WIFI_STATE_UNKNOWN
                    )) {
                        WifiManager.WIFI_STATE_ENABLED -> {
                            Log.e("wifiStateReceiver", "SSID: ${wifiManager.connectionInfo.ssid}")
                            activityCallback.onWifiStateEnabled()
                        }
                    }
                }
            }
        }
    }

    private val networkCallback: ConnectivityManager.NetworkCallback =
            object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    super.onAvailable(network)
                    if (isAndroidMarshmallowOrLater()) {
                        connectivityManager.bindProcessToNetwork(network)
                    }
                    activityCallback.onAvailable()
                }

                override fun onUnavailable() {
                    super.onUnavailable()
                    Log.e("TAG", "onUnavailable")
                    activityCallback.onUnavailable()
                }
            }

    override fun isWifiEnabled(): Boolean {
        return wifiManager.isWifiEnabled
    }

    override fun registerNetworkReceiver() {
        map[WIFI_STATE_RECEIVER] = true
        appContext.registerReceiver(
                wifiStateReceiver,
                IntentFilter(WifiManager.WIFI_STATE_CHANGED_ACTION)
        )
    }

    override fun unregisterNetworkReceiver() {
        if (map[WIFI_STATE_RECEIVER]!!) {
            map[WIFI_STATE_RECEIVER] = false
            appContext.unregisterReceiver(wifiStateReceiver)
        }

        if (map[WIFI_NETWORK_CALLBACK]!!) {
            map[WIFI_NETWORK_CALLBACK] = false
            connectivityManager.unregisterNetworkCallback(networkCallback)
        }
    }

    override fun turnOnWifi() {
        wifiManager.isWifiEnabled = true
    }

    override fun startScan() {
        if (wifiManager.startScan()) {
            Log.e("TAG", "start scanning")
            map[WIFI_SCAN_RECEIVER] = true
            appContext.registerReceiver(
                    wifiScanReceiver,
                    IntentFilter(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION)
            )
        } else {
            Log.e("TAG", "not scanning")
            activityCallback.onScanResult(arrayListOf())
        }
    }

    override fun stopScan() {
        if (map[WIFI_SCAN_RECEIVER]!!) {
            map[WIFI_SCAN_RECEIVER] = false
            appContext.unregisterReceiver(wifiScanReceiver)
        }
    }

    override fun buildAutoWifiConnection(result: ScanResult, pwd: String?) {
        Log.e("TAG", "START AutoWifiConnection with ${result.SSID} | $pwd")
        if (isAndroidQorLater()) {
            autoWifiConnectQOrLater(result, pwd)
        } else {
            autoWifiConnectPreQ(result, pwd)
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.Q)
    internal fun autoWifiConnectQOrLater(result: ScanResult, pwd: String?) {
        map[WIFI_NETWORK_CALLBACK] = true
        connectivityManager.requestNetwork(buildNetworkRequest(result, pwd), networkCallback)
    }

    @SuppressLint("MissingPermission")
    private fun autoWifiConnectPreQ(result: ScanResult, pwd: String?) {
        var configuration: WifiConfiguration? = null
        var i = -1
        for (configured in wifiManager.configuredNetworks) {
            if (configured.SSID == convertToQuotedString(result.SSID)) {
                Log.e("autoWifiConnectQ", "getting saved configuration")
                configuration = configured
                i = configured.networkId;
                break
            }
        }

        if (null == configuration) {
            Log.e("autoWifiConnectQ", "setting up configuration")
            configuration = getConfiguration(result, pwd)
            i = wifiManager.addNetwork(configuration)
        }

        if (i == -1) {
            activityCallback.onFailed("WifiException", "Unable to add configuration", "")
        }

        Log.e("autoWifiConnectQ", "configuration id: $i")

        wifiManager.disconnect()
        wifiManager.enableNetwork(i, true)
        wifiManager.reconnect()

        Handler().postDelayed({
            if (doesSSIDMatch(result.SSID)) {
                activityCallback.onSuccess(true)
            } else {
                activityCallback.onFailed("WifiException", "unable to connect to network", "")
            }
        }, 2000)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun getSpecificWifi(ssid: String, pwd: String?): WifiNetworkSpecifier {
        val builder = WifiNetworkSpecifier.Builder()
                .setSsidPattern(PatternMatcher(ssid, PatternMatcher.PATTERN_PREFIX))
        if (pwd != null) {
            builder.setWpa2Passphrase(pwd)
        }
        return builder.build()
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun getWifiSuggestion(ssid: String, pwd: String?): WifiNetworkSuggestion {
        val builder = WifiNetworkSuggestion.Builder()
                .setSsid(ssid)
        if (pwd != null) {
            builder.setWpa2Passphrase(pwd)
        }
        return builder.build()
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun getWifiSuggestionList(
            ssid: String,
            pwd: String?
    ): ArrayList<WifiNetworkSuggestion> {
        val list =
                ArrayList<WifiNetworkSuggestion>()
        list.add(getWifiSuggestion(ssid, pwd))
        return list
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun buildNetworkRequest(result: ScanResult, pwd: String?): NetworkRequest {
        return NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .removeCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                .setNetworkSpecifier(getSpecificWifi(result.SSID, pwd))
                .build()
    }

    override fun doesSSIDMatch(ssid: String): Boolean {
        return wifiManager.connectionInfo.ssid == convertToQuotedString(ssid)
    }

    private fun getConfiguration(result: ScanResult, password: String?): WifiConfiguration {
        val capabilities = result.capabilities.substring(1, result.capabilities.indexOf(']') - 1)
                .split('-')
                .toSet()
        val auth = capabilities.elementAtOrNull(0) ?: ""
        val keyManagement = capabilities.elementAtOrNull(1) ?: ""
        val pairwiseCipher = capabilities.elementAtOrNull(2) ?: ""

        val config = WifiConfiguration()
        config.SSID = convertToQuotedString(result.SSID)

        if (auth.contains("WPA") || auth.contains("WPA2")) {
            config.allowedProtocols.set(WifiConfiguration.Protocol.WPA)
            config.allowedProtocols.set(WifiConfiguration.Protocol.RSN)
        }

        if (auth.contains("EAP"))
            config.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.LEAP)
        else if (auth.contains("WPA") || auth.contains("WPA2"))
            config.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.OPEN)
        else if (auth.contains("WEP"))
            config.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.SHARED)

        if (keyManagement.contains("IEEE802.1X"))
            config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.IEEE8021X)
        else if (auth.contains("WPA") && keyManagement.contains("EAP"))
            config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_EAP)
        else if (auth.contains("WPA") && keyManagement.contains("PSK"))
            config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK)
        else if (auth.contains("WPA2") && keyManagement.contains("PSK"))
            config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK)
        else config.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE)

        if (pairwiseCipher.contains("CCMP") || pairwiseCipher.contains("TKIP")) {
            config.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP)
            config.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP)
        }

        if (password != null && password.isNotEmpty()) {
            if (auth.contains("WEP")) {
                if (password.matches("\\p{XDigit}+".toRegex())) {
                    config.wepKeys[0] = password
                } else {
                    config.wepKeys[0] = convertToQuotedString(password)
                }
                config.wepTxKeyIndex = 0
            } else {
                config.preSharedKey = convertToQuotedString(password)
            }
        } else {
            Log.e("getConfiguration", "password is null")
        }

        return config
    }
}