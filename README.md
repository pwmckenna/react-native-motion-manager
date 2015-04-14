# react-native-motion-manager

# MotionManager
This is a react app that shows how to write obj-c wrappers around the iOS [CMMotionManager](https://developer.apple.com/library/ios/documentation/CoreMotion/Reference/CMMotionManager_Class/)
 library.
# Usage
At this point, just copy and paste `iOS/Accelerometer.h` + `iOS/Accelerometer.m` (or Gyroscope or Magnetomer) into your `iOS` folder.  


Does anyone know how to share react-native components that are wrappers around native utilities?  
There must be a better way to package this stuff...  

# Api

### Setup
```js
var {
    Accelerometer,
    Gyroscope,
    Magnetometer
} = require('NativeModules');
var {
  DeviceEventEmitter // will emit events that you can listen to
} = React;
```


### Accelerometer
```js
Accelerometer.setAccelerometerUpdateInterval(0.1); // in seconds
DeviceEventEmitter.addListener('AccelerationData', function (data) {
  /**
  * data.acceleration.x
  * data.acceleration.y
  * data.acceleration.z
  **/
});
Accelerometer.startAccelerometerUpdates(); // you'll start getting AccelerationData events above
Accelerometer.stopAccelerometerUpdates();
```

### Gyroscope
```js
Gyroscope.setGyroUpdateInterval(0.1); // in seconds
DeviceEventEmitter.addListener('GyroData', function (data) {
  /**
  * data.rotationRate.x
  * data.rotationRate.y
  * data.rotationRate.z
  **/
});
Gyroscope.startGyroUpdates(); // you'll start getting AccelerationData events above
Gyroscope.stopGyroUpdates();
```

### Magnetomer
```js
Magnetometer.setAccelerometerUpdateInterval(0.1); // in seconds
DeviceEventEmitter.addListener('MagnetometerData', function (data) {
  /**
  * data.magneticField.x
  * data.magneticField.y
  * data.magneticField.z
  **/
});
Magnetometer.startMagnetometerUpdates(); // you'll start getting AccelerationData events above
Magnetometer.stopMagnetometerUpdates();
```

# Screenshots

![](http://pwmckenna.com/react-native-motion-manager/motion.png)
![](http://pwmckenna.com/react-native-motion-manager/accelerometer.png)
![](http://pwmckenna.com/react-native-motion-manager/gyroscope.png)
![](http://pwmckenna.com/react-native-motion-manager/magnetometer.png)
