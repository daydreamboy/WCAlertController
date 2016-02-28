//
//  WCAlertAnimatorSystem.m
//  Pods
//
//  Created by wesley chen on 16/2/25.
//
//

#import "WCAlertAnimatorSystem.h"

#import <WCAlertController/CAAnimationHelper.h>

@implementation WCAlertAnimatorSystem {
    CGFloat _showDuration;
    CGFloat _dismissDuration;
}

@synthesize showDuration = _showDuration;
@synthesize dismissDuration = _dismissDuration;

- (instancetype)init {
    self = [super init];

    if (self) {
        _showDuration = 0.25;
        _dismissDuration = 0.25;
    }

    return self;
}

- (CAAnimation *)animationsForShow {
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.20, 1.20, 1.00)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.00)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.00, 1.00, 1.00)]];
    NSArray *progressValues = @[@0.0, @0.5, @1.0];
    
    // Note: keyTimes for every frame is between 0%..100%, and the later one is must >= the former
    CAKeyframeAnimation *transformAnimation = [CAAnimationHelper transformAnimationWithFrameValues:frameValues
                                                                                    progressValues:progressValues];
    CABasicAnimation *opacityAnimation = [CAAnimationHelper opacityAnimationWithStartAlpha:0.5 endAlpha:1.0];

    CAAnimationGroup *animationGroup = [CAAnimationHelper animationGroupWithAnimations:@[transformAnimation, opacityAnimation]];

    animationGroup.duration = _showDuration;

    return animationGroup;
}

- (CAAnimation *)animationsForDismiss {
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.00, 1.00, 1.00)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.00)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.80, 0.80, 1.00)]];
    NSArray *progressValues = @[@0.0, @0.5, @1.0];
    
    CAKeyframeAnimation *transformAnimation = [CAAnimationHelper transformAnimationWithFrameValues:frameValues
                                                                                    progressValues:progressValues];

    CABasicAnimation *opacityAnimation = [CAAnimationHelper opacityAnimationWithStartAlpha:1.0 endAlpha:0.0];

    CAAnimationGroup *animationGroup = [CAAnimationHelper animationGroupWithAnimations:@[transformAnimation, opacityAnimation]];

    animationGroup.duration = _dismissDuration;

    return animationGroup;
}

@end
