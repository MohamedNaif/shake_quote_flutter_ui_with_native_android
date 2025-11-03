package com.example.shake_quote_flutter_ui_with_native_android

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager

class ShakeDetector(private val onShakeDetected: () -> Unit) : SensorEventListener {
    
    // Threshold for shake detection (you can adjust this value)
    private val SHAKE_THRESHOLD = 15.0f
    private val SHAKE_SLOP_TIME_MS = 500 // Minimum time between shakes
    
    private var lastShakeTime: Long = 0
    private var lastX: Float = 0f
    private var lastY: Float = 0f
    private var lastZ: Float = 0f
    
    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return
        
        val currentTime = System.currentTimeMillis()
        
        // Ignore if shake happened too recently
        if (currentTime - lastShakeTime < SHAKE_SLOP_TIME_MS) {
            return
        }
        
        val x = event.values[0]
        val y = event.values[1]
        val z = event.values[2]
        
        // Calculate acceleration change
        val deltaX = Math.abs(x - lastX)
        val deltaY = Math.abs(y - lastY)
        val deltaZ = Math.abs(z - lastZ)
        
        val acceleration = Math.sqrt(
            (deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ).toDouble()
        ).toFloat()
        
        // If acceleration is greater than threshold, it's a shake!
        if (acceleration > SHAKE_THRESHOLD) {
            lastShakeTime = currentTime
            onShakeDetected()
        }
        
        // Update last values
        lastX = x
        lastY = y
        lastZ = z
    }
    
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed for this implementation
    }
}

