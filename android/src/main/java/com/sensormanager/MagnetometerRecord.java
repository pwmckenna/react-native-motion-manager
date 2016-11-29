package com.sensormanager;

import android.hardware.Sensor;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;

import java.util.HashMap;
import java.util.Map;

public class MagnetometerRecord extends SensorRecord {

	private static final String MAGNETIC_FIELD_KEY = "magneticField";
	private static final String MAGNETOMETER_EVENT_KEY = "MagnetometerData";

	public MagnetometerRecord(ReactApplicationContext reactContext) {
		super(reactContext);
	}

	@Override
	public String getName() {
		return "Magnetometer";
	}

	@Override
	protected int getSensorType() {
		return Sensor.TYPE_MAGNETIC_FIELD;
	}

	@Override
	protected String getEventNameKey() {
		return MAGNETOMETER_EVENT_KEY;
	}

	@Override
	protected String getDataMapKey() {
		return MAGNETIC_FIELD_KEY;
	}

	/**
	 * @param delaySeconds Delay in seconds and/or fractions of a second.
	 */
	@ReactMethod
	public void setMagnetometerUpdateInterval(double delaySeconds) {
		setUpdateDelay(delaySeconds);
	}

	/**
	 * @return true if Magnetometer exists on device, false if it does not exist and so could not be started.
	 */
	@ReactMethod
	public void startMagnetometerUpdates(Callback onStarted) {
		startUpdates(onStarted);
	}

	@ReactMethod
	public void stopMagnetometerUpdates() {
		stopUpdates();
	}
}
