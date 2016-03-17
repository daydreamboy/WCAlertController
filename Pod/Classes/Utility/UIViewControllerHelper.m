//
//  UIViewControllerHelper.m
//  Pods
//
//  Created by wesley chen on 16/3/4.
//
//

#import "UIViewControllerHelper.h"

@implementation UIViewControllerHelper

+ (UIViewController *)rootViewControllerWithNavController:(UINavigationController *)navController {
    
    UIViewController *rootViewController;
    
    if ([navController isKindOfClass:[UINavigationController class]]) {
        NSArray *viewControllers = [navController viewControllers];
        
        if (viewControllers.count > 0) {
            rootViewController = viewControllers[0];
        }
    }
    
    return rootViewController;
}

@end
