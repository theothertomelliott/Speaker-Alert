/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Navigator
} from 'react-native';
import Start from './views/start.js'

class SpeakerAlert extends Component {
  render() {
    return (
      <Navigator
            initialRoute={{
              title: 'Start',
              index: 1,
            }}
            renderScene={this.renderScene}
          />
    )
  }
  renderScene(route, navigator) {
    return <Start
      title={route.title}
      loadProfile={() => {
              const nextIndex = route.index + 1;
              navigator.push({
                title: 'Scene ' + nextIndex,
                index: nextIndex,
              });
            }}
            // Function to call to go back to the previous scene
      onBack={() => {
          if (route.index > 0) {
            navigator.pop();
          }
      }}
      />
    }
}

AppRegistry.registerComponent('SpeakerAlert', () => SpeakerAlert);
