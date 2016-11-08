package com.sensormanager;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.concurrent.TimeUnit;

public class GyroscopeRecord extends ReactContextBaseJavaModule implements SensorEventListener {

    private SensorManager mSensorManager;
    private Sensor mGyroscope;
    private long lastUpdate = 0;
    private int i = 0;
	private int delay;

	private ReactContext mReactContext;
	private Arguments mArguments;


    public GyroscopeRecord(ReactApplicationContext reactContext) {
        super(reactContext);
        mSensorManager = (SensorManager)reactContext.getSystemService(reactContext.SENSOR_SERVICE);
		mReactContext = reactContext;
    }

    @Override
    public String getName() {
        return "Gyroscope";
    }

    /**
     * @param delay Delay in milliseconds.
     */
    @ReactMethod
    public void setGyroUpdateInterval(int delay) {
        this.delay = delay;
    }

    @ReactMethod
	public int startGyroUpdates() {

        if ((mGyroscope = mSensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)) != null) {
            int uSecs =(int) TimeUnit.MICROSECONDS.convert(this.delay, TimeUnit.MILLISECONDS);
			mSensorManager.registerListener(this, mGyroscope, uSecs);
			return (1);
		}
		return (0);
	}

    @ReactMethod
    public void stopGyroUpdates() {
        mSensorManager.unregisterListener(this);
    }

	private void sendEvent(String eventName, @Nullable WritableMap params)
	{
		try {
			mReactContext
				.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class) 
				.emit(eventName, params);
		} catch (RuntimeException e) {
			Log.e("ERROR", "java.lang.RuntimeException: Trying to invoke JS before CatalystInstance has been set!", e);
		}
	}

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        Sensor mySensor = sensorEvent.sensor;
		WritableMap map = mArguments.createMap();

        if (mySensor.getType() == Sensor.TYPE_GYROSCOPE) {
            map.putDouble("x", sensorEvent.values[0]);
            map.putDouble("y", sensorEvent.values[1]);
            map.putDouble("z", sensorEvent.values[2]);
            sendEvent("GyroData", map);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

}
