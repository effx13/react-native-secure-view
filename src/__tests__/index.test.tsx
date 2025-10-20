import { render } from '@testing-library/react-native';
import SecureView from './SecureView';

describe('SecureView', () => {
  it('renders without crashing', () => {
    const { getByTestId } = render(<SecureView testID="secure-view" />);
    expect(getByTestId('secure-view')).toBeTruthy();
  });

  it('renders with enable prop set to true', () => {
    const { getByTestId } = render(
      <SecureView testID="secure-view" enable={true} />
    );
    expect(getByTestId('secure-view')).toBeTruthy();
  });

  it('renders with enable prop set to false', () => {
    const { getByTestId } = render(
      <SecureView testID="secure-view" enable={false} />
    );
    expect(getByTestId('secure-view')).toBeTruthy();
  });

  it('accepts standard View props', () => {
    const { getByTestId } = render(
      <SecureView testID="secure-view" style={{ backgroundColor: 'red' }} />
    );
    expect(getByTestId('secure-view')).toBeTruthy();
  });
});
