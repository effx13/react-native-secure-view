# react-native-secure-view

A React Native component that protects content from screenshots and screen recordings. On iOS, you can selectively protect specific components while keeping the rest of the screen visible. Android provides full-screen protection.

## Demo

| iOS                                                                                             | Android                                                                                             |
| ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| ![iOS Example](https://github.com/user-attachments/assets/5605124b-625b-423d-a8e7-6edd635dd11a) | ![Android Example](https://github.com/user-attachments/assets/b66825bc-adcd-4fe0-a1c5-f2f1107eeec5) |

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

### iOS

Uses `UITextField` with `secureTextEntry` property to provide component-level protection:

- **Screenshots**: Only the `SecureView` component appears blank/hidden in the captured image
- **Screen recording**: Only the `SecureView` component appears blank during recording (rest of the screen remains visible)
- **Selective protection**: You can protect specific sensitive components while keeping other parts of your UI visible
- Works by leveraging iOS's built-in secure text field behavior that hides content during capture

### Android

Applies `WindowManager.LayoutParams.FLAG_SECURE` to the activity window:

- **Screenshots**: Completely blocked system-wide
- **Screen recording**: Entire screen appears black during recording
- **Recent apps switcher**: Shows a black screen instead of app content
- **Full-screen protection**: When enabled, the entire app window becomes secure

## Limitations

### iOS

- **Component-level only**: Protection is limited to the specific `SecureView` component area, not the entire screen

### Android

- **Full-screen only**: When enabled, the entire app screen becomes secure, not just the `SecureView` component
- **Rooted devices**: Protection may be bypassed on rooted or modified devices
- **System-level**: Applies to the entire activity window, affecting all content

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
