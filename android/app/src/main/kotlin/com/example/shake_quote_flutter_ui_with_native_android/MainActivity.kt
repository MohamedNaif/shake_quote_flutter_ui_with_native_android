package com.example.shake_quote_flutter_ui_with_native_android

import android.hardware.SensorManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SHAKE_EVENT_CHANNEL = "com.example.shake_quote/shake_events"
    private val SHAKE_METHOD_CHANNEL = "com.example.shake_quote/shake_methods"
    
    private var shakeDetector: ShakeDetector? = null
    private var sensorManager: SensorManager? = null
    private var accelerometer: android.hardware.Sensor? = null
    private var eventSink: EventChannel.EventSink? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize sensor manager
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(android.hardware.Sensor.TYPE_ACCELEROMETER)
        
        // Setup EventChannel for sending shake events to Flutter
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SHAKE_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    startShakeDetection()
                }
                
                override fun onCancel(arguments: Any?) {
                    stopShakeDetection()
                    eventSink = null
                }
            }
        )
        
        // Setup MethodChannel for Flutter to control shake detection
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHAKE_METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startShakeDetection" -> {
                    startShakeDetection()
                    result.success(true)
                }
                "stopShakeDetection" -> {
                    stopShakeDetection()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun startShakeDetection() {
        if (shakeDetector == null && accelerometer != null) {
            shakeDetector = ShakeDetector {
                // Send shake event to Flutter
                eventSink?.success("shake_detected")
            }
            
            sensorManager?.registerListener(
                shakeDetector,
                accelerometer,
                SensorManager.SENSOR_DELAY_UI
            )
        }
    }
    
    private fun stopShakeDetection() {
        shakeDetector?.let {
            sensorManager?.unregisterListener(it)
            shakeDetector = null
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        stopShakeDetection()
    }
}
