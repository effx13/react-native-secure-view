# react-native-secure-view

A React Native component that protects specific content from screenshots and screen recordings on both iOS and Android.

## Installation

```sh
npm install react-native-secure-view
```

## Usage

Wrap the content you want to protect from screenshots and screen recordings:

```jsx
import { SecureView } from 'react-native-secure-view';

function App() {
  return (
    <SecureView enable={true}>
      <Text>This content is protected from screenshots</Text>
      <Image source={require('./sensitive-image.png')} />
    </SecureView>
  );
}
```

### Props

| Prop     | Type      | Default | Description                             |
| -------- | --------- | ------- | --------------------------------------- |
| `enable` | `boolean` | `true`  | Enable or disable screenshot protection |

### Example

```jsx
import React, { useState } from 'react';
import { View, Text, Button } from 'react-native';
import { SecureView } from 'react-native-secure-view';

function App() {
  const [secure, setSecure] = useState(true);

  return (
    <View style={{ flex: 1 }}>
      <Button
        title={`Protection: ${secure ? 'ON' : 'OFF'}`}
        onPress={() => setSecure(!secure)}
      />

      <SecureView enable={secure}>
        <Text>Protected Content</Text>
      </SecureView>
    </View>
  );
}
```

## How It Works

### Android

When `enable={true}`, the module applies `WindowManager.LayoutParams.FLAG_SECURE` to the activity window:

- **Screenshots**: Completely blocked
- **Screen recording**: Entire screen appears black during recording
- Recent apps switcher shows a black screen

### iOS

Uses `UITextField` with `secureTextEntry` property:

- **Screenshots**: The `SecureView` component appears blank/hidden in the captured image
- **Screen recording**: Only the `SecureView` component appears blank during recording (rest of the screen is visible)
- Works by leveraging iOS's built-in secure text field behavior that hides content during capture

## Limitations

### Android

- **Entire screen protection**: When enabled, the entire app screen becomes secure, not just the `SecureView` component
- **Rooted devices**: May bypass protection on rooted/modified devices

### iOS

- **Component-level protection**: Only hides the specific `SecureView` component, not the entire screen

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
