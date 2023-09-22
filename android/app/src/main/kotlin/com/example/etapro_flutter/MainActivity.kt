package com.example.etapro_flutter

import android.location.Location

import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
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
                // We should already have permissions
                // https://developers.google.com/android/reference/com/google/android/gms/location/Priority
                fusedLocationClient.getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
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