import { useState } from 'react';
import { Button, StyleSheet, Switch, Text, View } from 'react-native';
import { SecureView } from 'react-native-secure-view';

export default function App() {
  const [isSecureEnabled, setIsSecureEnabled] = useState(true);

  return (
    <View style={styles.container}>
      <View style={styles.switchContainer}>
        <Text>Toggle Secure View</Text>
        <Switch value={isSecureEnabled} onValueChange={setIsSecureEnabled} />
      </View>
      <SecureView enable={isSecureEnabled} style={styles.box}>
        <View style={styles.content}>
          <Text style={styles.text}>This Text cannot be captured</Text>
          <Button title="Interaction Test" onPress={() => {}} />
        </View>
      </SecureView>
      <View style={styles.box}>
        <View style={styles.content}>
          <Text style={styles.text}>This Text can be captured</Text>
          <Button title="Interaction Test" onPress={() => {}} />
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 20,
  },
  switchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
  },
  box: {
    width: 200,
    height: 200,
  },
  content: {
    flex: 1,
    backgroundColor: 'blue',
  },
  text: {
    color: 'white',
    fontWeight: 'bold',
  },
  textInput: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    marginBottom: 10,
  },
});
