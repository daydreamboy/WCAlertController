//
//  UIResponder+WCAlertController.h
//  Pods
//
//  Created by wesley chen on 16/3/17.
//
//

#import <UIKit/UIKit.h>

@interface UIResponder (WCAlertController)

+ (id)currentFirstResponder;
+ (void)cacheKeyboard;
+ (void)cacheKeyboard:(BOOL)onNextRunloop;

@end
