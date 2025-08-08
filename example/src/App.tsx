import { View, StyleSheet, Text } from 'react-native';
import { SecureView } from 'react-native-secure-view';

export default function App() {
  return (
    <View style={styles.container}>
      <SecureView
        enable={true}
        style={styles.box}
        FallbackComponent={<Text>Fallback</Text>}
      >
        <Text>Helloㄴㅁㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹ</Text>
      </SecureView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
