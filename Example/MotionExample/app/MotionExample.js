/**
 * MotionManger
 *
 * Created by Patrick Williams in beautiful Seattle, WA.
 */
'use strict';

import React, {Component} from 'react';
import {
    View,
    Navigator
} from 'react-native';
import Button from 'react-native-button';

var GyroscopeManager = require('./../components/GyroscopeManager');
var AccelerometerManager = require('./../components/AccelerometerManager');
var MagnetometerManager = require('./../components/Magnetometer');

const ROUTES = {
    motion: {
        title: 'Motion'
    },
    gyroscope: {
        component: (<GyroscopeManager/>)
    },
    accelerometer: {
        component: (<AccelerometerManager/>)
    },
    magnetometer: {
        component: (<MagnetometerManager/>)
    }
};

class MotionExample extends Component {
    constructor(props) {
        super(props);
        this.handleNavigationPress = this.handleNavigationPress.bind(this);
        this.render = this.render.bind(this);
    }

    handleNavigationPress(route) {
        this.props.navigator.push(route);
    }

    render() {
        return (
            <View style={{
                flex: 1,
                paddingTop: 100,
              }}>
                <Button style={{fontSize: 30}}
                        onPress={() => this.handleNavigationPress(ROUTES.accelerometer)}>
                    Accelerometer
                </Button>
                <Button style={{fontSize: 30}}
                        onPress={() => this.handleNavigationPress(ROUTES.gyroscope)}>
                    Gyroscope
                </Button>
                <Button style={{fontSize: 30}}
                        onPress={() => this.handleNavigationPress(ROUTES.magnetometer)}>
                    Magnetometer
                </Button>
            </View>
        );
    }
}

class App extends Component {
    constructor(props) {
        super(props);
        this.render = this.render.bind(this);
    }

    render() {
        return (
            <Navigator
                initialRoute={ROUTES.motion}
                renderScene={(route, navigator) => {
                     if (route.title == 'Motion') {
                         return (<MotionExample navigator={navigator}/>)
                     }
                     else {
                         return route.component;
                     }
                }}
                style={{
                    flex: 1,
                    backgroundColor: '#ffffff'
                }}
            />
        );
    }
}

module.exports = App
