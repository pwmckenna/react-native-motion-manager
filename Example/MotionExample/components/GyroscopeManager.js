/**
 * GyroscopeManager
 *
 * Created by Patrick Williams in beautiful Seattle, WA.
 */
'use strict';

var React = require('react-native');
var Button = require('react-native-button');
var {
  Text,
  View,
  DeviceEventEmitter
} = React;

var {
    Gyroscope
} = require('NativeModules');


Gyroscope.setGyroUpdateInterval(0.1);

var GyroscopeManager = React.createClass({
  getInitialState: function () {
    return {
      x: 0,
      y: 0,
      z: 0,
      gyro: false
    }
  },
  componentDidMount: function () {
    DeviceEventEmitter.addListener('GyroData', function (data) {
      this.setState({
        x: data.rotationRate.x.toFixed(5),
        y: data.rotationRate.y.toFixed(5),
        z: data.rotationRate.z.toFixed(5)
      });
    }.bind(this));
  },
  componentWillUnmount: function () {
    Gyroscope.stopGyroUpdates();
  },
  handleStart: function () {
    Gyroscope.startGyroUpdates();
    this.setState({
      gyro: true
    });
  },
  handleStop: function () {
    Gyroscope.stopGyroUpdates();
    this.setState({
      x: 0,
      y: 0,
      z: 0,
      gyro: false
    });
  },
  render: function() {
    console.log(this.state);
    return (
      <View style={{
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
      }}>
        <Text>x: {this.state.x}</Text>
        <Text>y: {this.state.y}</Text>
        <Text>z: {this.state.z}</Text>
        {
          (this.state.gyro) ?
          <Button style={{color: 'red', margin: 20}} onPress={this.handleStop}>Stop</Button> :
          <Button style={{color: 'green', margin: 20}} onPress={this.handleStart}>Start</Button>
        }
      </View>
    );
  }
});

module.exports = GyroscopeManager;
