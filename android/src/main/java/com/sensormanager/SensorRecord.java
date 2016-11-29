package com.sensormanager;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.annotation.Nullable;

import com.connectedlab.reactnative.commonlib.ErrorBuilder;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.concurrent.TimeUnit;

import timber.log.Timber;

public abstract class SensorRecord extends ReactContextBaseJavaModule implements SensorEventListener {

    private SensorManager sensorManager;
    private Sensor sensor;
    private double delaySeconds;

    protected abstract int getSensorType();

    protected abstract String getEventNameKey();

    protected abstract String getDataMapKey();

    public SensorRecord(ReactApplicationContext reactContext) {
        super(reactContext);
        sensorManager = (SensorManager) reactContext.getSystemService(ReactApplicationContext.SENSOR_SERVICE);
    }

    protected void setUpdateDelay(double delaySeconds) {
        this.delaySeconds = delaySeconds;
    }

    protected void startUpdates(Callback onStarted) {
        if ((sensor = sensorManager.getDefaultSensor(getSensorType())) != null) {
            int uSecs = (int) (this.delaySeconds * TimeUnit.MICROSECONDS.convert(1, TimeUnit.SECONDS));
            Timber.d("Registering " + getName() + " with %s ms for ", uSecs, this);
            /*
             * Do not use this version (in API 19) to save battery:
             * public boolean registerListener(SensorEventListener listener, Sensor sensor, int samplingPeriodUs, int maxReportLatencyUs) {
             * As it reports erratic data.
             */
            sensorManager.registerListener(this, sensor, uSecs);
            onStarted.invoke((Object) null);
        } else {
            onStarted.invoke(new ErrorBuilder().toJavaScriptError("No " + getName() + " sensor"));
        }
    }

    protected void stopUpdates() {
        Timber.d("Stopping " + getName() + " updates for %s", this);
        sensorManager.unregisterListener(this);
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        try {
            getReactApplicationContext()
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        } catch (RuntimeException e) {
            Timber.e("Trying to invoke JS before CatalystInstance has been set!", e);
        }
    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        Sensor mySensor = sensorEvent.sensor;
        if (mySensor.getType() == getSensorType()) {
            WritableMap map = Arguments.createMap();
            WritableMap rotationRate = Arguments.createMap();

            rotationRate.putDouble("x", sensorEvent.values[0]);
            rotationRate.putDouble("y", sensorEvent.values[1]);
            rotationRate.putDouble("z", sensorEvent.values[2]);
            map.putMap(getDataMapKey(), rotationRate);

            sendEvent(getEventNameKey(), map);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    @Override
    public void onCatalystInstanceDestroy() {
        Timber.d("Stopping " + getName() + " updates because catalyst is destroyed for %s", this);
        stopUpdates();
        super.onCatalystInstanceDestroy();
    }
}
