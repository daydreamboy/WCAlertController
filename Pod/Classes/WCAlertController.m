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
        _contentViewController = viewController;
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

        if (_maskViewBlurred) {
            UIImage *snapshot = [[UIApplication sharedApplication].keyWindow captureScreenshot];
            _blurredImage = [UIImageHelper blurredImageWithImage:snapshot imageBlurStyle:WCImageBlurStyleOriginal];
        }
        else {
            _blurredImage = nil;
        }

        [self presentLayoutView];
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

- (void)setMaskViewColor:(UIColor *)maskViewColor {
    
    if (maskViewColor) {
        const CGFloat alpha = 0.6f;
        
        UIColor *appliedColor = maskViewColor;
        if (CGColorGetAlpha(maskViewColor.CGColor) == 1.0f) {
            appliedColor = [maskViewColor colorWithAlphaComponent:alpha];
        }
        
        _maskViewColor = appliedColor;
    }
}

#pragma mark Getters

- (UIViewController *)standOnViewController {
    return self.contentViewController.standOnViewController;
}

#pragma mark - Override Methods

- (void)dealloc {
    self.contentViewController.standOnViewController = nil;
    self.contentViewController = nil;
    
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

    self.maskViewColor = [UIColor darkGrayColor];
    _showDuration = 0.25;
    _dismissDuration = 0.25;

    // use WCAlertAnimationStyleSystem by default
    self.animationStyle = WCAlertAnimationStyleSystem;
}

- (void)presentLayoutView {
    if (!_alertOnViewController) {
        _overlapWindow.hidden = NO;
        [_overlapWindow makeKeyAndVisible];
    }
    else {
        self.view.hidden = NO;
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

#pragma mark - Animations

- (NSArray *)animatedLayers {
    return @[_maskView.layer, _containerView.layer];
}

- (NSArray *)animatorsForShow {
    CABasicAnimation *animationForMaskView = [CAAnimationHelper opacityAnimationWithStartAlpha:0.0 endAlpha:1.0];
    CAAnimation *animationProvided = [_animator animationsForShow];

    animationForMaskView.duration = _showDuration;
    animationProvided.duration = _showDuration;

    return @[animationForMaskView, animationProvided];
}

- (NSArray *)animatorsForDismiss {
    CABasicAnimation *animationForMaskView = [CAAnimationHelper opacityAnimationWithStartAlpha:1.0 endAlpha:0.0];
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

    _maskView.backgroundColor = _maskViewColor;
    _maskView.alpha = 1.0;
    _containerView.alpha = 1.0;

    [CAAnimationHelper animationWithLayers:animatedLayers
                                animations:animators
                                completion:^{
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

    _maskView.backgroundColor = _maskViewColor;
    _maskView.alpha = 1.0f;
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

    _maskView.alpha = 0.0;
    _containerView.alpha = 0.0;
    
    [CAAnimationHelper animationWithLayers:animatedLayers
                                animations:animators
                                completion:^{
        [_maskView removeFromSuperview];
        [_contentViewController.view removeFromSuperview];

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
                                    
        // disconnect alertController with standOnViewController
        self.contentViewController.standOnViewController.alertController = nil;
    }];
}

- (void)executeDismiss {
    [_contentViewController willMoveToParentViewController:nil];

    // Call viewWillDisappear: method
    [_contentViewController beginAppearanceTransition:NO animated:YES];

    _maskView.alpha = 0.0;
    _containerView.alpha = 0.0;
    
    [_maskView removeFromSuperview];

    [_contentViewController.view removeFromSuperview];

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

    // disconnect alertController with standOnViewController
    self.contentViewController.standOnViewController.alertController = nil;
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
