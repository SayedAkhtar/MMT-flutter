package ios.mmt_

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import android.os.PowerManager
import android.view.WindowManager
//import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import kotlin.math.min


class MainActivity: FlutterActivity(), SensorEventListener {
    private lateinit var sensorManager: SensorManager
    private lateinit var proximitySensor: Sensor
    private lateinit var powerManager: PowerManager
    private lateinit var wakeLock: PowerManager.WakeLock
    private lateinit var proximityEventChannel: EventChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        proximitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY)

        powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK, "ProximityLockTag")

        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        // Register an event channel for proximity sensor updates
        proximityEventChannel = EventChannel(flutterEngine!!.dartExecutor.binaryMessenger, "proximity_sensor_events")
        proximityEventChannel.setStreamHandler(ProximitySensorStreamHandler())
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed for proximity sensor
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            val proximityValue = it.values[0]
            if (proximityValue < proximitySensor.maximumRange) {
                // Object is close to the sensor
                wakeLock.acquire()
            } else {
                // Object is far from the sensor
                if(wakeLock.isHeld()) {
                    wakeLock.release()
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        sensorManager.registerListener(this, proximitySensor, SensorManager.SENSOR_DELAY_NORMAL)
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
        wakeLock.release()
    }
}
