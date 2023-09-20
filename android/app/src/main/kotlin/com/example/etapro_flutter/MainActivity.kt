package com.example.etapro_flutter

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.location.Location
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

import com.google.android.gms.location.LocationServices
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "native_gps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // TODO: Getting this client too many times? Do once and save the result?
        val fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->

            if (call.method == "getCurrentLocation") {
                // 102 is PRIORITY_BALANCED_POWER_ACCURACY
                // https://developers.google.com/android/reference/com/google/android/gms/location/Priority
                fusedLocationClient.getCurrentLocation(102, null)
                .addOnSuccessListener { 
                    location: Location? ->
                    result.success(doubleArrayOf(location!!.latitude, location.longitude))
                }                
            }
            else {
                result.notImplemented()
            }
        }
    }
}