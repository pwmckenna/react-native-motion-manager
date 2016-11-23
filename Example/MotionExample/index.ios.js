/**
 * MotionManger
 *
 * Created by Patrick Williams in beautiful Seattle, WA.
 */
'use strict';

import React, {Component} from 'react';
import {
  AppRegistry,
  Text,
  View,
  NavigatorIOS,
  TouchableHighlight,
  DeviceEventEmitter
} from 'react-native';
import Button from 'react-native-button';

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

class MotionExample extends Component {
  constructor(props) {
    super(props);
  }
  handleNavigationPress(route) {
    this.props.navigator.push(route);
  }
  _handlePress() {
    console.log('Pressed!');
  }
  render() {
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
};

routes.motion = {
  title: 'Motion',
  component: MotionExample
};

class App extends Component {
  render() {
    return (
      <NavigatorIOS
        style={{
          flex: 1,
          backgroundColor: '#ffffff'
        }}
        initialRoute={routes.motion} />
    );
  }
};

AppRegistry.registerComponent('MotionExample', () => App)
