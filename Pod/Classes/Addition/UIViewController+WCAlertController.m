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
static const char *const StandOnViewControllerObjectTag = "StandOnViewControllerObjectTag";

@dynamic alertController;

- (void)setAlertController:(WCAlertController *)alertController {
    objc_setAssociatedObject(self, AlertControllerObjectTag, alertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WCAlertController *)alertController {
    return objc_getAssociatedObject(self, AlertControllerObjectTag);
}

- (void)setStandOnViewController:(UIViewController *)standOnViewController {
    objc_setAssociatedObject(self, StandOnViewControllerObjectTag, standOnViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)standOnViewController {
    return objc_getAssociatedObject(self, StandOnViewControllerObjectTag);
}

- (void)dismissAlertControllerAnimated:(BOOL)animated {
    
    if (self.standOnViewController.alertController) {
        [self.standOnViewController.alertController dismissAlertAnimated:animated];
        return;
    }
    
    if (self.alertController && self.alertController.standOnViewController == self) {
        [self.alertController dismissAlertAnimated:animated];
        return;
    }
}

- (void)presentAlertController:(WCAlertController *)alertController animated:(BOOL)animated {
    if (alertController) {
        self.alertController = alertController;
        alertController.contentViewController.standOnViewController = self;
        [alertController presentAlertAnimated:animated];
    }
}

@end
