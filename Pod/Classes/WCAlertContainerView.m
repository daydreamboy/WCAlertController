//
//  WCAlertContainerView.m
//  WCAlertController
//
//  Created by wesley chen on 16/2/24.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "WCAlertContainerView.h"

@implementation WCAlertContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
//    NSLog(@"%@", view);

    if (view == self) {
        return nil;
    }

    return view;
}

@end
