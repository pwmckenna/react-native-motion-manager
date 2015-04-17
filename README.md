# react-native-motion-manager

CMMotionManager wrapper for react-native, exposing Accelerometer, Gyroscope, and Magnetometer.

### Add it to your project

1. Run `npm install react-native-motion-manager --save`
2. Open your project in XCode, right click on `Libraries` and click `Add
   Files to "Your Project Name"`.
3. Add `libRNMotionManager.a` to `Build Phases -> Link Binary With Libraries`
4. Click on `RNMotionManager.xcodeproj` in `Libraries` and go the `Build
   Phases` tab. Double click the text to the right of `Header Search
   Paths` and verify that it has `$(SRCROOT)../react-native/React` - if it
   isn't, then add it. This is so XCode is able to find the headers that
   the `RNMotionManager` source files are referring to by pointing to the
   header files installed within the `react-native` `node_modules`
   directory.

### Setup trouble?

If you get stuck, take a look at [Brent Vatne's blog](http://brentvatne.ca/packaging-react-native-component/). He was gracious enough to help out on this project, and his blog is my go to reference for this stuff.

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

# Example

This repo contains an example react-native app to help get you started. [Source code here.](https://github.com/pwmckenna/react-native-motion-manager/tree/master/Example/MotionExample)

![](http://pwmckenna.com/react-native-motion-manager/motion.png)
![](http://pwmckenna.com/react-native-motion-manager/accelerometer.png)
![](http://pwmckenna.com/react-native-motion-manager/gyroscope.png)
![](http://pwmckenna.com/react-native-motion-manager/magnetometer.png)
