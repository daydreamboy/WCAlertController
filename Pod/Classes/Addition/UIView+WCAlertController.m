//
//  UIView+WCAlertController.m
//  Pods
//
//  Created by wesley chen on 16/3/17.
//
//

#import "UIView+WCAlertController.h"

@implementation UIView (WCAlertController)

- (UIImage *)captureScreenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);

    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }

    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end
