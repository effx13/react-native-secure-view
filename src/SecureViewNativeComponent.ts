import { codegenNativeComponent, type ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  enable?: boolean;
}

export default codegenNativeComponent<NativeProps>('SecureView');
