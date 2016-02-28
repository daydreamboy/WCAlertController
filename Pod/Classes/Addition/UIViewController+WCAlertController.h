//
//  UIViewController+WCAlertController.h
//  Pods
//
//  Created by wesley chen on 16/2/26.
//
//

#import <UIKit/UIKit.h>

@class WCAlertController;

@interface UIViewController (WCAlertController)

@property (nonatomic, strong) WCAlertController *alertController;

- (void)dismissAlertControllerAnimated:(BOOL)animated;

@end
