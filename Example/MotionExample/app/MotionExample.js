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

var GyroscopeManager = require('./../components/GyroscopeManager');
var AccelerometerManager = require('./../components/AccelerometerManager');
var MagnetometerManager = require('./../components/Magnetometer');


class MotionExample extends Component {
    constructor(props) {
        super(props);
        this.handleNavigationPress = this.handleNavigationPress.bind(this);
        this.render = this.render.bind(this);

        this.routes = {
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
    }

    handleNavigationPress(route) {
        this.props.navigator.push(route);
    }

    render() {
        console.log('ROUTES', this.routes);

        return (
            <View style={{
        flex: 1,
        paddingTop: 100,
      }}>
                <Button onPress={() => this.handleNavigationPress(this.routes.accelerometer)}>Accelerometer</Button>
                <Button onPress={() => this.handleNavigationPress(this.routes.gyroscope)}>Gyroscope</Button>
                <Button onPress={() => this.handleNavigationPress(this.routes.magnetometer)}>Magnetometer</Button>
            </View>
        );
    }
};


class App extends Component {
    constructor(props) {
        super(props);
        this.render = this.render.bind(this);
        this.routes = {
            motion: {
                title: 'Motion',
                component: MotionExample
            }
        };

    }

    render() {
        return (
            <NavigatorIOS
                style={{
          flex: 1,
          backgroundColor: '#ffffff'
        }}
                initialRoute={this.routes.motion} />
        );
    }
};

AppRegistry.registerComponent('MotionExample', () => App)

module.exports = App
