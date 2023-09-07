package com.app.MyMedTrip

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler

class ProximitySensorStreamHandler: StreamHandler  {
    private var eventSink: EventSink? = null

    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun sendProximityEvent(isNear: Boolean) {
        eventSink?.success(isNear)
    }
}