import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button
} from 'react-native';

export default class Start extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text>
          {this.props.title}
        </Text>
        <Text style={styles.welcome}>
          Welcome to Speaker Alert!
        </Text>
        <Button title='Next Scene' onPress={this.props.loadProfile}/>
        <Button title='Previous Scene' onPress={this.props.onBack}/>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
