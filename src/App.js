import React, {Component} from 'react';
import {StyleSheet, View, Text} from 'react-native';
import http from './http';

export default class App extends Component {
  mounted: boolean;

  render() {
    return (
      <View style={styles.container}>
        <Text>Hello World!</Text>
      </View>
    );
  }
  componentDidMount() {
    this.mounted = true;
    this.mockNetwork().then(() => false);
  }
  componentWillUnmount() {
    this.mounted = false;
  }

  async mockNetwork() {
    const urls = [
      'https://google.com.br',
      'https://google.com.br/test123',
      'https://viacep.com.br/ws/01001000/json',
      'https://viacep.com.br/ws/15020035/json',
      'https://viacep.com.br/ws/1020035/json',
    ];

    // noinspection InfiniteLoopJS
    for (let i = 0; this.mounted; i++) {
      const url = urls[i % urls.length];
      const delay = 1000 * Math.random() * 3;
      console.log({delay});
      await sleep(delay);
      await http.get(url).catch(() => false);
      console.log(url);
    }
  }
}

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});
