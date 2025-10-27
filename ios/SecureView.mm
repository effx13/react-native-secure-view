#import "SecureView.h"

#import <react/renderer/components/SecureViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SecureViewSpec/EventEmitters.h>
#import <react/renderer/components/SecureViewSpec/Props.h>
#import <react/renderer/components/SecureViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@implementation SecureTextField

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  for (UIView *subview in self.subviews.reverseObjectEnumerator) {
    CGPoint convertedPoint = [subview convertPoint:point fromView:self];
    UIView *hitView = [subview hitTest:convertedPoint withEvent:event];
    if (hitView) {
      return hitView;
    }
  }
  
  return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
  for (UIView *subview in self.subviews) {
    CGPoint convertedPoint = [subview convertPoint:point fromView:self];
    if ([subview pointInside:convertedPoint withEvent:event]) {
      return YES;
    }
  }
  
  return NO;
}

@end

@interface SecureView () <RCTSecureViewViewProtocol>

@end

@implementation SecureView {
    SecureTextField *_secureTextField;
    UIView *_containerView;
    UIView *_protectorView;
    BOOL _isPreventingCapture;
    NSArray<NSLayoutConstraint *> *_containerConstraints;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<SecureViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        static const auto defaultProps = std::make_shared<const SecureViewProps>();
        _props = defaultProps;
        
        [self setupSecureView];
    }
    
    return self;
}

- (void)setupSecureView
{
    // Create container view for child components
    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.userInteractionEnabled = YES;
    
    // Create secure text field (this is the key to screenshot prevention)
    _secureTextField = [[SecureTextField alloc] init];
    _secureTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _secureTextField.borderStyle = UITextBorderStyleNone;
    _secureTextField.backgroundColor = [UIColor clearColor];
    _secureTextField.userInteractionEnabled = YES;
    _secureTextField.secureTextEntry = YES; // Enable screenshot prevention
    _secureTextField.enabled = NO; // Disable edit
    
    // Important: Add views in correct order
    [self addSubview:_secureTextField];
    
    // Setup constraints
    [self setupConstraints];
    
    // Default state
    _isPreventingCapture = YES;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self setupProtectorView];
}

- (void)setupProtectorView
{
    if (_protectorView) return;
  
    
    // The secure text field creates internal subviews that get hidden during screenshots
    for (UIView *subview in _secureTextField.subviews) {
        _protectorView = subview;
        break;
    }
    
    if (!_protectorView) {
        // Create our own view if no suitable subview exists
        _protectorView = [[UIView alloc] init];
        [_secureTextField addSubview:_protectorView];
    }
    
    // Add container to the protector view
    _protectorView.translatesAutoresizingMaskIntoConstraints = NO;
    _protectorView.userInteractionEnabled = YES;
    [_protectorView addSubview:_containerView];
  
    // Enable interaction for container
    _containerView.userInteractionEnabled = YES;
    
    // Make protector view fill the text field
    [NSLayoutConstraint activateConstraints:@[
        [_protectorView.leadingAnchor constraintEqualToAnchor:_secureTextField.leadingAnchor],
        [_protectorView.trailingAnchor constraintEqualToAnchor:_secureTextField.trailingAnchor],
        [_protectorView.topAnchor constraintEqualToAnchor:_secureTextField.topAnchor],
        [_protectorView.bottomAnchor constraintEqualToAnchor:_secureTextField.bottomAnchor]
    ]];
    
    // Make container fill the protector view
    [NSLayoutConstraint activateConstraints:@[
        [_containerView.leadingAnchor constraintEqualToAnchor:_protectorView.leadingAnchor],
        [_containerView.trailingAnchor constraintEqualToAnchor:_protectorView.trailingAnchor],
        [_containerView.topAnchor constraintEqualToAnchor:_protectorView.topAnchor],
        [_containerView.bottomAnchor constraintEqualToAnchor:_protectorView.bottomAnchor]
    ]];
}

- (void)setupConstraints
{
    [NSLayoutConstraint activateConstraints:@[
        // Secure text field constraints
        [_secureTextField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_secureTextField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_secureTextField.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_secureTextField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
    ]];
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<SecureViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<SecureViewProps const>(props);
    
    // Handle enable prop
    if (oldViewProps.enable != newViewProps.enable) {
        _isPreventingCapture = newViewProps.enable;
        _secureTextField.secureTextEntry = _isPreventingCapture;
        
        if (_containerConstraints) {
            [NSLayoutConstraint deactivateConstraints:_containerConstraints];
        }
      
        // If disabling protection, ensure content is visible
        if (!_isPreventingCapture) {
            _containerView.hidden = NO;
            _secureTextField.hidden = YES;
            // Move container view to self if protection is disabled
            [_containerView removeFromSuperview];
          
            [self addSubview:_containerView];
            [self sendSubviewToBack:_containerView];
            
            _containerConstraints = @[
                [_containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [_containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [_containerView.topAnchor constraintEqualToAnchor:self.topAnchor],
                [_containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
            ];
          
            [NSLayoutConstraint activateConstraints:_containerConstraints];
        } else {
            _secureTextField.hidden = NO;
            if (!_protectorView) {
                [self setupProtectorView];
            } else {
                [_containerView removeFromSuperview];
                [_protectorView addSubview:_containerView];
            }
        }
    }
    
    [super updateProps:props oldProps:oldProps];
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
    // Add children directly to container view
    childComponentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView insertSubview:childComponentView atIndex:index];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
    [childComponentView removeFromSuperview];
}

Class<RCTComponentViewProtocol> SecureViewCls(void)
{
    return SecureView.class;
}

@end
