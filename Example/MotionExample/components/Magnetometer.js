/**
 * MagnetometerManager
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

var {
    Magnetometer
} = require('NativeModules');


Magnetometer.setMagnetometerUpdateInterval(0.1);

var MagnetometerManager = React.createClass({
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
        DeviceEventEmitter.addListener('MagnetometerData', function (data) {
            this.setState({
                x: data.magneticField.x.toFixed(5),
                y: data.magneticField.y.toFixed(5),
                z: data.magneticField.z.toFixed(5)
            });
        }.bind(this));
    },
    componentWillUnmount: function () {
        Magnetometer.stopMagnetometerUpdates();
    },
    handleStart: function () {
        Magnetometer.startMagnetometerUpdates((error) => {
            if (error) {
                console.error(error);
            } else {
                this.setState({startedSuccess: true});
            }
        });

        this.setState({
            gyro: true
        });
    },
    handleStop: function () {
        Magnetometer.stopMagnetometerUpdates();
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

module.exports = MagnetometerManager;
