//
//  UIResponder+WCAlertController.m
//  Pods
//
//  Created by wesley chen on 16/3/17.
//
//

#import "UIResponder+WCAlertController.h"

static __weak id sCurrentFirstResponder_WCAlertController;

static BOOL sHasAlreadyCachedKeyboard_WCAlertController;

@implementation UIResponder (WCAlertController)

#pragma mark - First Responder

+ (id)currentFirstResponder {
    sCurrentFirstResponder_WCAlertController = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return sCurrentFirstResponder_WCAlertController;
}

- (void)findFirstResponder:(id)sender {
    sCurrentFirstResponder_WCAlertController = self;
}

#pragma mark - Keyboard

+ (void)cacheKeyboard {
    [[self class] cacheKeyboard:NO];
}

+ (void)cacheKeyboard:(BOOL)onNextRunloop {
    if (!sHasAlreadyCachedKeyboard_WCAlertController) {
        sHasAlreadyCachedKeyboard_WCAlertController = YES;

        if (onNextRunloop) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0), dispatch_get_main_queue(), ^(void) { [[self class] __cacheKeyboard]; });
        }
        else {
            [[self class] __cacheKeyboard];
        }
    }
}

+ (void)__cacheKeyboard {
    UITextField *field = [UITextField new];

    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:field];
    [field becomeFirstResponder];
    [field resignFirstResponder];
    [field removeFromSuperview];
}

@end
