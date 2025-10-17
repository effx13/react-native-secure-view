import { View, StyleSheet, Text } from 'react-native';
import { SecureView } from 'react-native-secure-view';

export default function App() {
  return (
    <View style={styles.container}>
      <SecureView enable={true} style={styles.box}>
        <View style={styles.content}>
          <Text style={styles.text}>This Text cannot be captured</Text>
        </View>
      </SecureView>
      <View style={styles.box}>
        <View style={styles.content}>
          <Text style={styles.text}>This Text can be captured</Text>
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
});
