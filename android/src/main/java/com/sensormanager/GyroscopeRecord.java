package com.sensormanager;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.concurrent.TimeUnit;

import timber.log.Timber;

public class GyroscopeRecord extends ReactContextBaseJavaModule implements SensorEventListener {

    private SensorManager mSensorManager;
    private Sensor mGyroscope;
	private double delaySeconds;

    public GyroscopeRecord(ReactApplicationContext reactContext) {
        super(reactContext);
        mSensorManager = (SensorManager)reactContext.getSystemService(reactContext.SENSOR_SERVICE);
    }

    @Override
    public String getName() {
        return "Gyroscope";
    }

    /**
     * @param delaySeconds Delay in seconds and/or fractions of a second.
     */
    @ReactMethod
    public void setGyroUpdateInterval(double delaySeconds) {
        this.delaySeconds = delaySeconds;
    }

    /**
     * @return true if Gyroscope exists on device, false if it does not exist and so could not be started.
     */
    @ReactMethod
	public boolean startGyroUpdates() {
        if ((mGyroscope = mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)) != null) {
            int uSecs = (int) (this.delaySeconds * TimeUnit.MICROSECONDS.convert(1, TimeUnit.SECONDS));
            Timber.d("Registering gyro with %s ms for ", uSecs, this);
            /*
             * Do not use this version (in API 19) to save battery:
             * public boolean registerListener(SensorEventListener listener, Sensor sensor, int samplingPeriodUs, int maxReportLatencyUs) {
             * As it reports erratic data.
             */
			mSensorManager.registerListener(this, mGyroscope, uSecs);
			return true;
		}
        Timber.d("No gryoscope sensor");
		return false;
	}

    @ReactMethod
    public void stopGyroUpdates() {
        Timber.d("Stopping gyro updates for", this);
        mSensorManager.unregisterListener(this);
    }

	private void sendEvent(String eventName, @Nullable WritableMap params)
	{
		try {
			getReactApplicationContext()
				.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class) 
				.emit(eventName, params);
		} catch (RuntimeException e) {
			Log.e("ERROR", "java.lang.RuntimeException: Trying to invoke JS before CatalystInstance has been set!", e);
		}
	}

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        Sensor mySensor = sensorEvent.sensor;
        if (mySensor.getType() == Sensor.TYPE_GYROSCOPE) {
		    WritableMap map = Arguments.createMap();
            WritableMap rotationRate = Arguments.createMap();

            rotationRate.putDouble("x", sensorEvent.values[0]);
            rotationRate.putDouble("y", sensorEvent.values[1]);
            rotationRate.putDouble("z", sensorEvent.values[2]);
            map.putMap("rotationRate", rotationRate);

            sendEvent("GyroData", map);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    @Override
    public void onCatalystInstanceDestroy() {
        Timber.d("Stopping gyro updates because catalyst is destroyed for %s", this);
        stopGyroUpdates();
        super.onCatalystInstanceDestroy();
    }

}
