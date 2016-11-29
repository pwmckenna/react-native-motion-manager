package com.sensormanager;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import timber.log.Timber;

public class GyroscopeRecord extends SensorRecord {

    private static final String ROTATION_RATE_KEY = "rotationRate";
    private static final String GYRO_EVENT_KEY = "GyroData";

    public GyroscopeRecord(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "Gyroscope";
    }

    @Override
    protected int getSensorType() {
        return Sensor.TYPE_GYROSCOPE;
    }

    @Override
    protected String getEventNameKey() {
        return GYRO_EVENT_KEY;
    }

    @Override
    protected String getDataMapKey() {
        return ROTATION_RATE_KEY;
    }

    /**
     * @param delaySeconds Delay in seconds and/or fractions of a second.
     */
    @ReactMethod
    public void setGyroUpdateInterval(double delaySeconds) {
        setUpdateDelay(delaySeconds);
    }

    /**
     * @return true if Gyroscope exists on device, false if it does not exist and so could not be started.
     */
    @ReactMethod
	public void startGyroUpdates(Callback onStarted) {
        startUpdates(onStarted);
    }

    @ReactMethod
    public void stopGyroUpdates() {
        stopUpdates();
    }

}
