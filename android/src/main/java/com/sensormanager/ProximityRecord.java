package com.sensormanager;

import android.os.Bundle;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;
import android.support.annotation.Nullable;

import java.io.*;
import java.util.Date;
import java.util.Timer;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.ReactApplicationContext;

public class ProximityRecord implements SensorEventListener {

    private SensorManager mSensorManager;
    private Sensor mProximity;
    private long lastUpdate = 0;
    private int i = 0;
    private int delay;

    private ReactContext mReactContext;
    private Arguments mArguments;

    public ProximityRecord(ReactApplicationContext reactContext) {
        mSensorManager = (SensorManager)reactContext.getSystemService(reactContext.SENSOR_SERVICE);
        mReactContext = reactContext;
    }

	public int start(int delay) {
        this.delay = delay;
        if ((mProximity = mSensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY)) != null) {
            mSensorManager.registerListener(this, mProximity, SensorManager.SENSOR_DELAY_FASTEST);
            return (1);
        }
        return (0);
    }

    public void stop() {
        mSensorManager.unregisterListener(this);
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        try {
            mReactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
        } catch (RuntimeException e) {
            Log.e("ERROR", "java.lang.RuntimeException: Trying to invoke JS before CatalystInstance has been set!");
        }
    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        Sensor mySensor = sensorEvent.sensor;
        WritableMap map = mArguments.createMap();
        double maxRange = mProximity.getMaximumRange();

        if (mySensor.getType() == Sensor.TYPE_PROXIMITY) {
            long curTime = System.currentTimeMillis();

            if ((curTime - lastUpdate) > delay) {
                boolean isNear = false;
                double value = sensorEvent.values[0];

                // NOTE: Android devices vary in the values they provide. A reasonably
                // safe rule of thumb is that if the value is less than the maximum range
                // of the sensor, then the phone is reporting that something is "near".
                // See https://developer.android.com/guide/topics/sensors/sensors_position.html
                // for more details. We also provide the raw value and maximum range in case
                // those are needed.
                map.putBoolean("isNear", value < maxRange);
                map.putDouble("value", value);
                map.putDouble("maxRange", maxRange);

                sendEvent("Proximity", map);
                lastUpdate = curTime;
            }
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
