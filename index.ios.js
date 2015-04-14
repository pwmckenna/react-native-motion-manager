/**
 * MotionManger
 *
 * Created by Patrick Williams in beautiful Seattle, WA.
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  Text,
  View,
  NavigatorIOS,
  TouchableHighlight,
  DeviceEventEmitter
} = React;
var Button = require('react-native-button');

var GyroscopeManager = require('./components/GyroscopeManager');
var AccelerometerManager = require('./components/AccelerometerManager');
var MagnetometerManager = require('./components/Magnetometer');

var routes = {
  gyroscope: {
    title: 'Gyroscope',
    component: GyroscopeManager
  },
  accelerometer: {
    title: 'Accelerometer',
    component: AccelerometerManager
  },
  magnetometer: {
    title: 'Magnetometer',
    component: MagnetometerManager
  }
};

var MotionManager = React.createClass({
  handleNavigationPress: function (route) {
    this.props.navigator.push(route);
  },
  render: function () {
    return (
      <View style={{
        flex: 1,
        paddingTop: 100,
      }}>
        <Button onPress={this.handleNavigationPress.bind(this, routes.accelerometer)}>Accelerometer</Button>
        <Button onPress={this.handleNavigationPress.bind(this, routes.gyroscope)}>Gyroscope</Button>
        <Button onPress={this.handleNavigationPress.bind(this, routes.magnetometer)}>Magnetometer</Button>
      </View>
    );
  }
});

routes.motion = {
  title: 'Motion',
  component: MotionManager
};

var App = React.createClass({
  render: function () {
    return (
      <NavigatorIOS
        style={{
          flex: 1,
          backgroundColor: '#ffffff'
        }}
        initialRoute={routes.motion} />
    );
  }
});

AppRegistry.registerComponent('MotionManager', function () {
  return App
});
