package com.example.flutterapp

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.content.Intent
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class CustomSwitchPlugin : FlutterActivity() {

    companion object {
        private const val CHANNEL = "flutterapp/custom"

        private const val REQUEST_CODE_FOR_TURN_ON_LOCATION = 0x00
    }

    private lateinit var result: MethodChannel.Result;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, post ->
            result = post;
            when (call.method) {
                "bluetoothSwitch" -> turnOnBluetooth()
                "locationSwitch" -> turnOnLocation()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        when (requestCode) {
            REQUEST_CODE_FOR_TURN_ON_LOCATION -> if (resultCode == Activity.RESULT_OK) result.success(1) else result.success(0)

        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun turnOnBluetooth() {
        try {
            val adapter = BluetoothAdapter.getDefaultAdapter()
            adapter.enable()
            result.success(1)
        } catch (e: Exception) {
            result.notImplemented()
        }
    }

    private fun turnOnLocation() {
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        startActivityForResult(
                intent,
                REQUEST_CODE_FOR_TURN_ON_LOCATION
        )
    }
}
