//
//  WCAlertController.h
//  WCAlertController
//
//  Created by wesley chen on 16/2/24.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

// Public Headers
#import <WCAlertController/WCAlertControllerDefinition.h>
#import <WCAlertController/WCAlertAnimator.h>
#import <WCAlertController/UIViewController+WCAlertController.h>

@interface WCAlertController : UIViewController

#pragma mark Alert properties

/*!
 *  Default is WCAlertAnimationStyleSystem
 */
@property (nonatomic, assign) WCAlertAnimationStyle animationStyle;

@property (nonatomic, assign, readonly, getter=isPresented) BOOL presented;
@property (nonatomic, strong, readonly) UIViewController *contentViewController;
@property (nonatomic, strong, readonly) UIViewController *standOnViewController;
/**
 *  Set the frame.size of contentViewController.view and will ignore self.view.frame set in viewDidLoad/viewWillAppear/viewDidAppear
 *
 *  Default is size of the screen
 *
 *  @warning If not set, push view controller will change alert'size base on current view controller's view
 */
@property (nonatomic, assign) CGSize contentSize;

#pragma mark MaskView properties

@property (nonatomic, assign) CGFloat maskViewAlpha;
@property (nonatomic, strong) UIColor *maskViewColor;
@property (nonatomic, assign) BOOL modal;

/**
 *  Confict with @maskViewAlpha and @maskViewColor. If YES, these properties won't work
 *
 *  Default is NO
 */
@property (nonatomic, assign) BOOL maskViewBlurred;


#pragma mark Animation properties

/**
 *  Default is animator's showDuration
 *  
 *  @warning If showDuration <= 0, use animator's showDuration instead
 */
@property (nonatomic, assign) CGFloat showDuration;
/**
 *  Default is animator's dismissDuration
 *
 *  @warning If dismissDuration <= 0, use animator's dismissDuration instead
 */
@property (nonatomic, assign) CGFloat dismissDuration;

/*!
 *  Use a custom animator must define animationStyle to WCAlertAnimationStyleCustom
 */
@property (nonatomic, strong) id<WCAlertAnimator> animator;

#pragma mark

// alert on UIWindow
- (instancetype)initWithContentViewController:(UIViewController *)viewController;
- (instancetype)initWithContentViewController:(UIViewController *)viewController completion:(WCAlertControllerCompletion)completion;

// alert on UIViewController
- (instancetype)initWithContentViewController:(UIViewController *)viewController fromHostViewController:(UIViewController *)hostViewController;
- (instancetype)initWithContentViewController:(UIViewController *)viewController fromHostViewController:(UIViewController *)hostViewController completion:(WCAlertControllerCompletion)completion;

- (void)presentAlertAnimated:(BOOL)animated;
- (void)dismissAlertAnimated:(BOOL)animated;

@end
