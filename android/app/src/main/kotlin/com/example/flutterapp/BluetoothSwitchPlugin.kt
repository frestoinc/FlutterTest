package com.example.flutterapp

import android.bluetooth.BluetoothAdapter
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.Exception

class BluetoothSwitchPlugin : FlutterActivity() {

    companion object {
        private const val CHANNEL = "flutterapp/custom"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "helloFromNativeCode" -> {
                    val greetings: String = helloFromNativeCode()
                    result.success(greetings)
                }

                "bluetoothSwitch" -> {
                    try {
                        val adapter = BluetoothAdapter.getDefaultAdapter()
                        adapter.enable()
                        result.success("OK")
                    } catch (e: Exception) {
                        result.notImplemented()
                    }

                }

            }
        }
    }

    private fun helloFromNativeCode(): String {
        return "Hello from Native Android Code";
    }
}
