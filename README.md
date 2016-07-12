# react-native-motion-manager

CMMotionManager wrapper for react-native, exposing Accelerometer, Gyroscope, and Magnetometer.

### Add it to your project

1. `npm install react-native-motion-manager@latest --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-motion-manager` and add `RNMotionManager.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `libRNMotionManager.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Click `RNMotionManager.xcodeproj` in the project navigator and go the `Build Settings` tab. Make sure 'All' is toggled on (instead of 'Basic'). Look for `Header Search Paths` and make sure it contains both `$(SRCROOT)/../react-native/React` and `$(SRCROOT)/../../React` - mark both as `recursive`.
5. Run your project (`Cmd+R`)

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
Magnetometer.setMagnetometerUpdateInterval(0.1); // in seconds
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
