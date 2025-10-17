#import "SecureView.h"

#import <react/renderer/components/SecureViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/SecureViewSpec/EventEmitters.h>
#import <react/renderer/components/SecureViewSpec/Props.h>
#import <react/renderer/components/SecureViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface SecureView () <RCTSecureViewViewProtocol>

@end

@implementation SecureView {
    UITextField *_secureTextField;
    UIView *_containerView;
    UIView *_captureView;
    BOOL _isPreventingCapture;
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
    // Create capture detection view (shown when screenshot is taken)
    _captureView = [[UIView alloc] init];
    _captureView.translatesAutoresizingMaskIntoConstraints = NO;
    _captureView.backgroundColor = [UIColor clearColor]; // Default capture background
    
    // Create container view for child components
    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    
    // Create secure text field (this is the key to screenshot prevention)
    _secureTextField = [[UITextField alloc] init];
    _secureTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _secureTextField.borderStyle = UITextBorderStyleNone;
    _secureTextField.backgroundColor = [UIColor clearColor];
    _secureTextField.userInteractionEnabled = NO;
    _secureTextField.secureTextEntry = YES; // Enable screenshot prevention
    
    // Important: Add views in correct order
    [self addSubview:_captureView];
    [self addSubview:_secureTextField];
    
    // Setup constraints
    [self setupConstraints];
    
    // Default state
    _isPreventingCapture = YES;
    
    // Setup the protector view after the text field is ready
    [self performSelector:@selector(setupProtectorView) withObject:nil afterDelay:0.1];
}

- (void)setupProtectorView
{
    // Find the protector view (UITextFieldLabel or similar internal view)
    UIView *protectorView = nil;
    
    // The secure text field creates internal subviews that get hidden during screenshots
    for (UIView *subview in _secureTextField.subviews) {
        NSString *className = NSStringFromClass([subview class]);
        // Look for the internal view that gets hidden (usually has frame CGRectZero or is UITextFieldLabel)
        if ([className containsString:@"UITextFieldLabel"] ||
            [className containsString:@"CanvasView"] ||
            CGRectEqualToRect(subview.frame, CGRectZero)) {
            protectorView = subview;
            break;
        }
    }
    
    if (!protectorView && _secureTextField.subviews.count > 0) {
        // If we can't find a specific view, use the first subview
        protectorView = _secureTextField.subviews.firstObject;
    }
    
    if (!protectorView) {
        // Create our own view if no suitable subview exists
        protectorView = [[UIView alloc] init];
        protectorView.translatesAutoresizingMaskIntoConstraints = NO;
        [_secureTextField addSubview:protectorView];
    }
    
    // Add container to the protector view
    protectorView.translatesAutoresizingMaskIntoConstraints = NO;
    [protectorView addSubview:_containerView];
    
    // Make protector view fill the text field
    [NSLayoutConstraint activateConstraints:@[
        [protectorView.leadingAnchor constraintEqualToAnchor:_secureTextField.leadingAnchor],
        [protectorView.trailingAnchor constraintEqualToAnchor:_secureTextField.trailingAnchor],
        [protectorView.topAnchor constraintEqualToAnchor:_secureTextField.topAnchor],
        [protectorView.bottomAnchor constraintEqualToAnchor:_secureTextField.bottomAnchor]
    ]];
    
    // Make container fill the protector view
    [NSLayoutConstraint activateConstraints:@[
        [_containerView.leadingAnchor constraintEqualToAnchor:protectorView.leadingAnchor],
        [_containerView.trailingAnchor constraintEqualToAnchor:protectorView.trailingAnchor],
        [_containerView.topAnchor constraintEqualToAnchor:protectorView.topAnchor],
        [_containerView.bottomAnchor constraintEqualToAnchor:protectorView.bottomAnchor]
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
        
        // Capture view constraints
        [_captureView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_captureView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_captureView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_captureView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
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
        
        // If disabling protection, ensure content is visible
        if (!_isPreventingCapture) {
            _secureTextField.hidden = YES;
            _containerView.hidden = NO;
            // Move container view to self if protection is disabled
            [_containerView removeFromSuperview];
            [self addSubview:_containerView];
            [self sendSubviewToBack:_containerView];
            
            [NSLayoutConstraint activateConstraints:@[
                [_containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
                [_containerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
                [_containerView.topAnchor constraintEqualToAnchor:self.topAnchor],
                [_containerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
            ]];
        } else {
            _secureTextField.hidden = NO;
            // Re-setup the protector view when enabling
            [self setupProtectorView];
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
