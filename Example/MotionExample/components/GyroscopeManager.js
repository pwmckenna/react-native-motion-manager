/**
 * GyroscopeManager
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
    Gyroscope
} = require('NativeModules');


Gyroscope.setGyroUpdateInterval(0.1);

var GyroscopeManager = React.createClass({
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
        Gyroscope.startGyroUpdates((error) => {
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
        Gyroscope.stopGyroUpdates();
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

module.exports = GyroscopeManager;
