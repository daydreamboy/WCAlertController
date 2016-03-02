//
//  UIView+Snapshot.m
//  Pods
//
//  Created by wesley chen on 16/3/1.
//
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *)captureScreenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);

    // IOS7及其后续版本
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:
                                     @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = NO;//设置为YES时,iPhone6截屏时界面会出现闪动问题
        [invocation setArgument:&arg2 atIndex:2];
        [invocation setArgument:&arg3 atIndex:3];
        [invocation invoke];
    }
    else {   // IOS7之前的版本
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }

    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end
