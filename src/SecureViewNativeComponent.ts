import type { ViewProps } from 'react-native';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ReactElement } from 'react';

interface NativeProps extends ViewProps {
  enable?: boolean;
  FallbackComponent?: ReactElement;
}

export default codegenNativeComponent<NativeProps>('SecureView');
