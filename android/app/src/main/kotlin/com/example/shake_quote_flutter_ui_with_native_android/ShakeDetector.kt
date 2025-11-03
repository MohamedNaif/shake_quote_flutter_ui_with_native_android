package com.example.shake_quote_flutter_ui_with_native_android

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import kotlin.math.sqrt

/**
 * Enhanced Shake Detector using accelerometer data.
 * 
 * This detector uses a combination of force vector calculation and low-pass filtering
 * to accurately detect phone shakes while filtering out false positives.
 */
class ShakeDetector(
    private val onShakeDetected: () -> Unit,
    // Configurable threshold (m/s²) - adjust based on sensitivity needs
    private val shakeThreshold: Float = 12.0f,
    // Minimum time between shake events (prevents spam)
    private val shakeSlopTimeMs: Long = 500L,
    // Low-pass filter alpha (0.0 to 1.0) - lower = more filtering, smoother
    private val filterAlpha: Float = 0.8f
) : SensorEventListener {
    
    companion object {
        // Standard gravity constant in m/s²
        private const val GRAVITY_EARTH = 9.80665f
        
        // Minimum number of samples before detection becomes active
        private const val MIN_SAMPLES = 10
    }
    
    // Timing control
    private var lastShakeTime: Long = 0
    private var sampleCount: Int = 0
    
    // Previous filtered values (for low-pass filter)
    private var lastX: Float = 0f
    private var lastY: Float = 0f
    private var lastZ: Float = 0f
    
    // Current filtered values
    private var filteredX: Float = 0f
    private var filteredY: Float = 0f
    private var filteredZ: Float = 0f
    
    // Flag to track initialization
    private var isInitialized: Boolean = false
    
    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null || event.values.size < 3) return
        
        val currentTime = System.currentTimeMillis()
        val x = event.values[0]
        val y = event.values[1]
        val z = event.values[2]
        
        // Initialize filtered values on first sample
        if (!isInitialized) {
            filteredX = x
            filteredY = y
            filteredZ = z
            lastX = x
            lastY = y
            lastZ = z
            isInitialized = true
            return
        }
        
        // Apply low-pass filter to reduce noise
        // This smooths out rapid fluctuations while keeping real movements
        filteredX = filterAlpha * filteredX + (1 - filterAlpha) * x
        filteredY = filterAlpha * filteredY + (1 - filterAlpha) * y
        filteredZ = filterAlpha * filteredZ + (1 - filterAlpha) * z
        
        // Increment sample count for warm-up period
        sampleCount++
        if (sampleCount < MIN_SAMPLES) {
            lastX = filteredX
            lastY = filteredY
            lastZ = filteredZ
            return
        }
        
        // Prevent shake spam (debouncing)
        if (currentTime - lastShakeTime < shakeSlopTimeMs) {
            return
        }
        
        // Calculate force vector (acceleration without gravity)
        // This is more accurate than just using raw acceleration differences
        val deltaX = filteredX - lastX
        val deltaY = filteredY - lastY
        val deltaZ = filteredZ - lastZ
        
        // Calculate the magnitude of the acceleration change
        // Using squared values first to avoid sqrt if possible (optimization)
        val accelerationSquared = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
        val thresholdSquared = shakeThreshold * shakeThreshold
        
        // If acceleration change exceeds threshold, it's a shake!
        if (accelerationSquared > thresholdSquared) {
            lastShakeTime = currentTime
            
            // Calculate actual acceleration for logging (optional)
            val acceleration = sqrt(accelerationSquared)
            
            // Trigger shake detection callback
            onShakeDetected()
        }
        
        // Update last filtered values for next comparison
        lastX = filteredX
        lastY = filteredY
        lastZ = filteredZ
    }
    
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Handle sensor accuracy changes
        // Lower accuracy might indicate sensor issues, but we continue anyway
        when (accuracy) {
            SensorManager.SENSOR_STATUS_ACCURACY_HIGH -> {
                // Best accuracy, no action needed
            }
            SensorManager.SENSOR_STATUS_ACCURACY_MEDIUM -> {
                // Medium accuracy, still acceptable
            }
            SensorManager.SENSOR_STATUS_ACCURACY_LOW -> {
                // Low accuracy - sensor might need calibration
                // Could optionally reset filter here, but we'll continue
            }
            SensorManager.SENSOR_STATUS_UNRELIABLE -> {
                // Sensor is unreliable - reset initialization
                isInitialized = false
                sampleCount = 0
            }
        }
    }
    
    /**
     * Reset the detector state. Useful when restarting detection.
     */
    fun reset() {
        isInitialized = false
        sampleCount = 0
        lastShakeTime = 0
        lastX = 0f
        lastY = 0f
        lastZ = 0f
        filteredX = 0f
        filteredY = 0f
        filteredZ = 0f
    }
}

