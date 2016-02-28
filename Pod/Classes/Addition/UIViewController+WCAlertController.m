//
//  UIViewController+WCAlertController.m
//  Pods
//
//  Created by wesley chen on 16/2/26.
//
//

#import "UIViewController+WCAlertController.h"

#import <WCAlertController/WCAlertController.h>
#import <objc/runtime.h>

@implementation UIViewController (WCAlertController)

static const char *const AlertControllerObjectTag = "AlertControllerObjectTag";

@dynamic alertController;

- (void)setAlertController:(WCAlertController *)alertController {
    objc_setAssociatedObject(self, AlertControllerObjectTag, alertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WCAlertController *)alertController {
    return objc_getAssociatedObject(self, AlertControllerObjectTag);
}

- (void)dismissAlertControllerAnimated:(BOOL)animated {
    if (self.alertController) {
        [self.alertController dismissAlertAnimated:animated];
    }
}

@end
