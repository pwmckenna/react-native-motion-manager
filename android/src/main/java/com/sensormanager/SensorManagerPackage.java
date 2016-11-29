package com.sensormanager;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * React native specific class
 */
@SuppressWarnings("unused")
public class SensorManagerPackage implements ReactPackage {

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new GyroscopeRecord(reactContext));
        modules.add(new AccelerometerRecord(reactContext));
        modules.add(new MagnetometerRecord(reactContext));
        return modules;
    }

    @Override
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

	@Override
	public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
		return Arrays.<ViewManager>asList();
	}
}
