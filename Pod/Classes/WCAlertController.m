//
//  WCAlertController.m
//  WCAlertController
//
//  Created by wesley chen on 16/2/24.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "WCAlertController.h"

#import <Accelerate/Accelerate.h>

#import <WCAlertController/WCAlertMaskView.h>
#import <WCAlertController/WCAlertContainerView.h>
#import <WCAlertController/WCAlertControllerMacro.h>
#import <WCAlertController/CAAnimationHelper.h>
#import <WCAlertController/UIView+Snapshot.h>
#import <WCAlertController/UIImageHelper.h>

#import <WCAlertController/WCAlertAnimator.h>
#import <WCAlertController/WCAlertAnimatorSystem.h>

@interface WCAlertController () {
    WCAlertMaskView *_maskView;
    WCAlertContainerView *_containerView;
    UIWindow *_overlapWindow;
    UIViewController *_hostViewController;
    BOOL _alertOnViewController;
    BOOL _backgroundTapped;
    BOOL _showAnimated;
    BOOL _dismissAnimated;

    WCAlertController *_retainedSelf;

    UIImage *_blurredImage;
}

@property (nonatomic, strong, readwrite) UIViewController *contentViewController;
@property (nonatomic, assign, readwrite) BOOL presented;
@property (nonatomic, copy) WCAlertControllerCompletion animationCompletion;

@end

@implementation WCAlertController

#pragma mark - Public Methods

- (instancetype)initWithContentViewController:(UIViewController *)viewController {
    return [self initWithContentViewController:viewController fromHostViewController:nil completion:nil];
}

- (instancetype)initWithContentViewController:(UIViewController *)viewController completion:(WCAlertControllerCompletion)completion {
    return [self initWithContentViewController:viewController fromHostViewController:nil completion:completion];
}

- (instancetype)initWithContentViewController:(UIViewController *)viewController fromHostViewController:(UIViewController *)hostViewController {
    return [self initWithContentViewController:viewController fromHostViewController:hostViewController completion:nil];
}

- (instancetype)initWithContentViewController:(UIViewController *)viewController fromHostViewController:(UIViewController *)hostViewController completion:(WCAlertControllerCompletion)completion {
    // do some assumptions
    NSAssert(viewController != nil || hostViewController != nil,
             @"both of viewController and hostViewController should not be nil");

    NSAssert(([viewController isKindOfClass:[UINavigationController class]] || [viewController isKindOfClass:[UIViewController class]]),
             @"%@ contentViewController is not supported", viewController);

    self = [super init];

    if (self) {
        _retainedSelf = self;
        _contentViewController = viewController;
        _contentViewController.alertController = self;
        _hostViewController = hostViewController;
        _animationCompletion = [completion copy];

        _alertOnViewController = hostViewController ? YES : NO;

        [self setup];
    }

    return self;
}

- (void)presentAlertAnimated:(BOOL)animated {
    if (!_presented) {
        [self allowUserInteractionEvents:NO];
        _presented = YES;
        _showAnimated = animated;

        UIImage *snapshot = [[UIApplication sharedApplication].keyWindow captureScreenshot];
//        _blurImage = [snapshot blurredImageWithRadius:8.0
//                                           iterations:8.0
//                                            tintColor:[[UIColor blueColor] colorWithAlphaComponent:0.8]];//[UIColor colorWithWhite:.0 alpha:0.2]];

        _blurredImage = [UIImageHelper blurredImageWithImage:snapshot imageBlurStyle:WCImageBlurStyleOriginal];
//        _blurImage = [UIImageHelper blurredImageWithImage:snapshot tintColor:[UIColor yellowColor] maskColor:[UIColor greenColor]];
        
        [self presentOverlapWindowIfNeeded];
        [self addMaskView];
        [self addContainerView];
        [self layoutAllViews];

        if (_showAnimated) {
            [self executeShowWithLayers:[self animatedLayers] animators:[self animatorsForShow]];
        }
        else {
            [self executeShow];
        }
    }
}

- (void)dismissAlertAnimated:(BOOL)animated {
    _dismissAnimated = animated;
    [self dismissWithBackgroundTapped:NO];
}

#pragma mark Setters

- (void)setAnimationStyle:(WCAlertAnimationStyle)animationStyle {
    _animationStyle = animationStyle;
    switch (_animationStyle) {
        case WCAlertAnimationStyleSystem:
            _animator = [WCAlertAnimatorSystem new];
            break;

        default:
            break;
    }
    _showDuration = [_animator showDuration];
    _dismissDuration = [_animator dismissDuration];
}

- (void)setShowDuration:(CGFloat)showDuration {
    if (showDuration > 0) {
        _showDuration = showDuration;
    }
}

- (void)setDismissDuration:(CGFloat)dismissDuration {
    if (dismissDuration > 0) {
        _dismissDuration = dismissDuration;
    }
}

#pragma mark - Override Methods

- (void)dealloc {
    _overlapWindow = nil;
}

#pragma mark Container View Controller

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark

- (void)setup {
    if (_alertOnViewController) {
        CGSize hostViewSize = _hostViewController.view.frame.size;
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, hostViewSize.width, hostViewSize.height)];
    }
    else {
        _overlapWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _overlapWindow.windowLevel = UIWindowLevelAlert;
        _overlapWindow.backgroundColor = [UIColor clearColor];
    }

    _maskView = [[WCAlertMaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    _containerView = [[WCAlertContainerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _containerView.backgroundColor = [UIColor clearColor];

    _maskViewAlpha = 0.6;
    _maskViewColor = [UIColor darkGrayColor];
    _showDuration = 0.25;
    _dismissDuration = 0.25;

    // use WCAlertAnimationStyleSystem by default
    self.animationStyle = WCAlertAnimationStyleSystem;
}

- (void)presentOverlapWindowIfNeeded {
    if (!_alertOnViewController) {
        _overlapWindow.hidden = NO;
        [_overlapWindow makeKeyAndVisible];
    }
}

- (void)addMaskView {
    if (!_modal) {
        [_maskView addTarget:self action:@selector(maskViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [_maskView removeTarget:self action:@selector(maskViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    }

    if (_maskViewBlurred) {
        _maskView.layer.contents = (id)_blurredImage.CGImage;
    }
    else {
        _maskView.layer.contents = nil;
    }
    
    if (_alertOnViewController) {
        [self.view addSubview:_maskView];
    }
    else {
        [_overlapWindow addSubview:_maskView];
    }
}

- (void)addContainerView {
    if (_alertOnViewController) {
        [self.view insertSubview:_containerView aboveSubview:_maskView];
        [_hostViewController.view addSubview:self.view];
    }
    else {
        [_overlapWindow insertSubview:_containerView aboveSubview:_maskView];
    }
}

- (void)addContentView {
    UIView *contentView = _contentViewController.view;

    [_containerView addSubview:contentView];
}

- (void)removeMaskView {
    [_maskView removeFromSuperview];
}

- (void)removeContainerView {
    [_containerView removeFromSuperview];
}

- (void)layoutAllViews {
    UIView *contentView = _contentViewController.view;

//    contentView.autoresizingMask = UIViewAutoresizingNone;
    if ([_contentViewController isKindOfClass:[UINavigationController class]]) {
        NSArray *viewControllers = [(UINavigationController *)_contentViewController viewControllers];
        UIViewController *rootViewController;

        if (viewControllers.count > 0) {
            rootViewController = viewControllers[0];
        }

        NSAssert(rootViewController, @"%@ should have a root view controller", _contentViewController);

        contentView = rootViewController.view;
    }

    CGSize contentViewSize = contentView.frame.size;
    CGSize overlayWindowSize = _alertOnViewController ? _hostViewController.view.frame.size : _overlapWindow.frame.size;

    CGFloat x = (overlayWindowSize.width - contentViewSize.width) / 2.0;
    CGFloat y = (overlayWindowSize.height - contentViewSize.height) / 2.0;

    _containerView.frame = CGRectMake(x, y, contentViewSize.width, contentViewSize.height);
    contentView.frame = CGRectMake(0, 0, contentViewSize.width, contentViewSize.height);

    if ([_contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)_contentViewController;
        navController.view.frame = contentView.frame;
    }
}

- (void)dismissWithBackgroundTapped:(BOOL)backgroundTapped {
    if (_presented) {
        [self allowUserInteractionEvents:NO];
        _presented = NO;

        _backgroundTapped = backgroundTapped;

        if (_dismissAnimated) {
            [self executeDismissWithLayers:[self animatedLayers] animators:[self animatorsForDismiss]];
        }
        else {
            [self executeDismiss];
        }
    }
}

- (void)addBlurToView:(UIView *)view {
    UIView *blurView = nil;

    if ([UIBlurEffect class]) { // iOS 8
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = view.frame;
    }
    else {   // workaround for iOS 7
        blurView = [[UIToolbar alloc] initWithFrame:view.bounds];
    }

    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [view addSubview:blurView];

//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(blurView)]];
//    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(blurView)]];
}

#pragma mark - Animations

- (NSArray *)animatedLayers {
    return @[_maskView.layer, _containerView.layer];
}

- (NSArray *)animatorsForShow {
    CABasicAnimation *animationForMaskView = [CAAnimationHelper opacityAnimationWithStartAlpha:0.0 endAlpha:1];
    CAAnimation *animationProvided = [_animator animationsForShow];

    animationForMaskView.duration = _showDuration;
    animationProvided.duration = _showDuration;

    return @[animationForMaskView, animationProvided];
}

- (NSArray *)animatorsForDismiss {
    CABasicAnimation *animationForMaskView = [CAAnimationHelper opacityAnimationWithStartAlpha:_maskViewAlpha endAlpha:0.0];
    CAAnimation *animationProvided = [_animator animationsForDismiss];

    animationForMaskView.duration = _dismissDuration;
    animationProvided.duration = _dismissDuration;

    return @[animationForMaskView, animationProvided];
}

- (void)executeShowWithLayers:(NSArray *)animatedLayers animators:animators {
    // @sa https://www.safaribooksonline.com/library/view/the-core-ios/9780133510119/ch07lev2sec18.html
    [self addChildViewController:_contentViewController];
    [self addContentView];

    // Call viewWilAppear: method
    [_contentViewController beginAppearanceTransition:YES animated:YES];

//    _maskView.backgroundColor = _maskViewColor;
//    _maskView.alpha = 1;

    _containerView.alpha = 1;
//    _maskView.backgroundColor = [UIColor whiteColor];


    [CAAnimationHelper animationWithLayers:animatedLayers
                                animations:animators
                                completion:^{
//        _maskView.alpha = _maskViewAlpha;
//        _maskView.backgroundColor = [UIColor whiteColor];
//        _containerView.alpha = 1.0;

        [_contentViewController didMoveToParentViewController:self];
        BLOCK_SAFE_RUN(_animationCompletion, _contentViewController, YES, _backgroundTapped);

        // Call viewDidAppear: method
        [_contentViewController endAppearanceTransition];
        [self allowUserInteractionEvents:YES];
    }];
}

- (void)executeShow {
    [self addChildViewController:_contentViewController];
    [self addContentView];

    // Call viewWilAppear: method
    [_contentViewController beginAppearanceTransition:YES animated:YES];

//    _maskView.backgroundColor = _maskViewColor;
//    _maskView.alpha = _maskViewAlpha;

    _containerView.alpha = 1.0;

    [_contentViewController didMoveToParentViewController:self];
    BLOCK_SAFE_RUN(_animationCompletion, _contentViewController, YES, _backgroundTapped);

    // Call viewDidAppear: method
    [_contentViewController endAppearanceTransition];

    [self allowUserInteractionEvents:YES];
}

- (void)executeDismissWithLayers:(NSArray *)animatedLayers animators:animators {
    [_contentViewController willMoveToParentViewController:nil];

    // Call viewWillDisappear: method
    [_contentViewController beginAppearanceTransition:NO animated:YES];

    [CAAnimationHelper animationWithLayers:animatedLayers
                                animations:animators
                                completion:^{
        _maskView.alpha = 0.0;
        [_maskView removeFromSuperview];
        [_contentViewController.view removeFromSuperview];
        _contentViewController.alertController = nil;     // Disconnect associated object

        if (_alertOnViewController) {
            self.view.hidden = YES;
            [self.view removeFromSuperview];
        }
        else {
            _overlapWindow.hidden = YES;
        }

        [_contentViewController removeFromParentViewController];
        BLOCK_SAFE_RUN(_animationCompletion, _contentViewController, NO, _backgroundTapped);

        // Call viewDidDisappear: method
        [_contentViewController endAppearanceTransition];
        //        [self allowBackSwipeGesture:YES];
        [self allowUserInteractionEvents:YES];
        // Call dealloc
        _retainedSelf = nil;
    }];
}

- (void)executeDismiss {
    [_contentViewController willMoveToParentViewController:nil];

    // Call viewWillDisappear: method
    [_contentViewController beginAppearanceTransition:NO animated:YES];

    _maskView.alpha = 0.0;
    [_maskView removeFromSuperview];

    [_contentViewController.view removeFromSuperview];
    _contentViewController.alertController = nil; // Disconnect associated object

    [_containerView removeFromSuperview];

    if (_alertOnViewController) {
        self.view.hidden = YES;
        [self.view removeFromSuperview];
    }
    else {
        _overlapWindow.hidden = YES;
    }

    [_contentViewController removeFromParentViewController];

    BLOCK_SAFE_RUN(_animationCompletion, _contentViewController, NO, _backgroundTapped);

    // Call viewDidDisappear: method
    [_contentViewController endAppearanceTransition];
    [self allowUserInteractionEvents:YES];

    // Call dealloc
    _retainedSelf = nil;
}

#pragma mark - Actions

- (void)maskViewTapped:(id)sender {
    _dismissAnimated = YES;
    [self dismissWithBackgroundTapped:YES];
}

#pragma mark - Utility Methods

- (void)allowUserInteractionEvents:(BOOL)isAllow {
    if (isAllow) {
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }
    else {
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
    }
}

/*!
 *  Disable or enable back swipe gesture in UINavigationController on iOS 7+
 */
- (void)allowBackSwipeGesture:(BOOL)isAllow {
//    if ([_hostViewController isKindOfClass:[UINavigationController class]]
//        && [((UINavigationController *)_hostViewController) respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        ((UINavigationController *)_hostViewController).interactivePopGestureRecognizer.enabled = isAllow;
//    }
}

@end
