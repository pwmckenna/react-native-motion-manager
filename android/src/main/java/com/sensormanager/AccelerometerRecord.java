package com.sensormanager;

import android.hardware.Sensor;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;

import java.util.HashMap;
import java.util.Map;

public class AccelerometerRecord extends SensorRecord {

    private static final String ACCELERATION_KEY = "acceleration";
    private static final String ACCELEROMETER_EVENT_KEY = "AccelerationData";

    public AccelerometerRecord(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "Accelerometer";
    }

    @javax.annotation.Nullable
    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(ACCELERATION_KEY, ACCELERATION_KEY);
        constants.put(ACCELEROMETER_EVENT_KEY, ACCELEROMETER_EVENT_KEY);
        return super.getConstants();
    }

    @Override
    protected int getSensorType() {
        return Sensor.TYPE_ACCELEROMETER;
    }

    @Override
    protected String getEventNameKey() {
        return ACCELEROMETER_EVENT_KEY;
    }

    @Override
    protected String getDataMapKey() {
        return ACCELERATION_KEY;
    }

    /**
     * @param delaySeconds Delay in seconds and/or fractions of a second.
     */
    @ReactMethod
    public void setAccelerometerUpdateInterval(double delaySeconds) {
        setUpdateDelay(delaySeconds);
    }

    /**
     * @return true if Gyroscope exists on device, false if it does not exist and so could not be started.
     */
    @ReactMethod
    public boolean startAccelerometerUpdates() {
        return startUpdates();
    }

    @ReactMethod
    public void stopAccelerometerUpdates() {
        stopUpdates();
    }

}
