//
//  WCAlertAnimatorFade.m
//  Pods
//
//  Created by wesley chen on 16/3/6.
//
//

#import "WCAlertAnimatorFade.h"

#import <WCAlertController/CAAnimationHelper.h>

@implementation WCAlertAnimatorFade {
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
    
    CABasicAnimation *opacityAnimation = [CAAnimationHelper opacityAnimationWithStartAlpha:0.5 endAlpha:1.0];
    opacityAnimation.duration = _showDuration;
    opacityAnimation.removedOnCompletion = YES;
    
    return opacityAnimation;
}

- (CAAnimation *)animationsForDismiss {
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.00, 1.00, 1.00)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.00)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.80, 0.80, 1.00)]];
    NSArray *progressValues = @[@0.0, @0.5, @1.0];
    
    CAKeyframeAnimation *transformAnimation = [CAAnimationHelper transformAnimationWithFrameValues:frameValues
                                                                                    progressValues:progressValues];
    
    CABasicAnimation *opacityAnimation = [CAAnimationHelper opacityAnimationWithStartAlpha:1.0 endAlpha:0.0];
    
    CAAnimationGroup *animationGroup = [CAAnimationHelper animationGroupWithAnimations:@[opacityAnimation, transformAnimation]];
    animationGroup.removedOnCompletion = YES;
    
    animationGroup.duration = _dismissDuration;
    
    return animationGroup;
}

@end
