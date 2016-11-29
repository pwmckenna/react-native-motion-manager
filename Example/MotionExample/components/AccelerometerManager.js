/**
 * AccelerometerManager
 *
 * Created by Patrick Williams in beautiful Seattle, WA.
 */
'use strict';

import React from 'react';
import Button from 'react-native-button';
import {
    Text,
    View,
    DeviceEventEmitter
} from 'react-native'

import {
    Accelerometer
} from 'NativeModules';


Accelerometer.setAccelerometerUpdateInterval(0.1);

var AccelerometerManager = React.createClass({
    getInitialState: function () {
        return {
            x: 0,
            y: 0,
            z: 0,
            gyro: false,
            startedSuccess: true
        }
    },
    componentDidMount: function () {
        DeviceEventEmitter.addListener('AccelerationData', function (data) {
            this.setState({
                x: data.acceleration.x.toFixed(5),
                y: data.acceleration.y.toFixed(5),
                z: data.acceleration.z.toFixed(5)
            });
        }.bind(this));
    },
    componentWillUnmount: function () {
        Accelerometer.stopAccelerometerUpdates();
    },
    handleStart: function () {
        Accelerometer.startAccelerometerUpdates((error) => {
            if (error) {
                console.log(error);
            }
            this.setState({startedSuccess: !error});
        });

        this.setState({
            gyro: true
        });
    },
    handleStop: function () {
        Accelerometer.stopAccelerometerUpdates();
        this.setState({
            x: 0,
            y: 0,
            z: 0,
            gyro: false
        });
    },
    render: function () {
        console.log(this.state);
        let noSensor = null;
        if (!this.state.startedSuccess) {
            noSensor = (<Text>No Sensor Available on Device</Text>)
        }
        return (
            <View style={{
                flex: 1,
                justifyContent: 'center',
                alignItems: 'center'
            }}>
                <Text>x: {this.state.x}</Text>
                <Text>y: {this.state.y}</Text>
                <Text>z: {this.state.z}</Text>
                {noSensor}
                {
                    (this.state.gyro) ?
                        <Button style={{color: 'red', margin: 20}} onPress={this.handleStop}>Stop</Button> :
                        <Button style={{color: 'green', margin: 20}} onPress={this.handleStart}>Start</Button>
                }
            </View>
        );
    }
});

module.exports = AccelerometerManager;
