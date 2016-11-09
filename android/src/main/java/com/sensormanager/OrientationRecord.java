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

public class OrientationRecord implements SensorEventListener {

    private SensorManager mSensorManager;
    private Sensor mAccelerometer;
    private Sensor mMagnetometer;
    private long lastUpdate = 0;
    private int i = 0, n = 0;
    private int delay;
    private int isRegistered = 0;

    private ReactContext mReactContext;
    private Arguments mArguments;


    public OrientationRecord(ReactApplicationContext reactContext) {
        mSensorManager = (SensorManager)reactContext.getSystemService(reactContext.SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        mMagnetometer = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        mReactContext = reactContext;
    }

    public int start(int delay) {
        this.delay = delay;
        if (mAccelerometer != null && isRegistered == 0) {
            mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_UI);
            mSensorManager.registerListener(this, mMagnetometer, SensorManager.SENSOR_DELAY_UI);
            isRegistered = 1;
            return (1);
        }
        return (0);
    }

    public void stop() {
        if (isRegistered == 1) {
            mSensorManager.unregisterListener(this);
        isRegistered = 0;
      }
    }

    private void sendEvent(String eventName, @Nullable WritableMap params)
    {
        try {
            mReactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
        } catch (RuntimeException e) {
            Log.e("ERROR", "java.lang.RuntimeException: Trying to invoke JS before CatalystInstance has been set!");
        }
    }

    float[] mGravity;
    float[] mGeomagnetic;

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
      Sensor mySensor = sensorEvent.sensor;
      WritableMap map = mArguments.createMap();

      if (mySensor.getType() == Sensor.TYPE_ACCELEROMETER)
        mGravity = sensorEvent.values;
      if (mySensor.getType() == Sensor.TYPE_MAGNETIC_FIELD)
        mGeomagnetic = sensorEvent.values;
      if (mGravity != null && mGeomagnetic != null) {
        float R[] = new float[9];
        float I[] = new float[9];
        boolean success = mSensorManager.getRotationMatrix(R, I, mGravity, mGeomagnetic);
        if (success) {
          long curTime = System.currentTimeMillis();
          float orientation[] = new float[3];
          mSensorManager.getOrientation(R, orientation);

          float heading = (float)((Math.toDegrees(orientation[0])) % 360.0f);
          float pitch = (float)((Math.toDegrees(orientation[1])) % 360.0f);
          float roll = (float)((Math.toDegrees(orientation[2])) % 360.0f);

          if (heading < 0) {
            heading = 360 - (0 - heading);
          }

          if (pitch < 0) {
            pitch = 360 - (0 - pitch);
          }

          if (roll < 0) {
            roll = 360 - (0 - roll);
          }

          map.putDouble("azimuth", heading);
          map.putDouble("pitch", pitch);
          map.putDouble("roll", roll);
          sendEvent("Orientation", map);
          lastUpdate = curTime;
        }
      }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }
}
