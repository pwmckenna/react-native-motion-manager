import NoOpMock from "./NoOpMock";

var {NativeModules} = require('react-native');
NativeModules.Gyroscope = NoOpMock.newMock();
NativeModules.Accelerometer = NoOpMock.newMock();
NativeModules.Magnetometer = NoOpMock.newMock();