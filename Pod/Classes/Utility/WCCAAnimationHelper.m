//
//  CAAnimationHelper.m
//  CAAnimationHelper
//
//  Created by wesley_chen on 15/1/25.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCCAAnimationHelper.h"

@implementation WCCAAnimationHelper

/*!
 *  Get an animation for changing alpha
 *
 *  @param startAlpha the alpha on start
 *  @param endAlpha   the alpha on end
 *
 */
+ (CABasicAnimation *)opacityAnimationWithStartAlpha:(CGFloat)startAlpha endAlpha:(CGFloat)endAlpha {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(startAlpha);
    opacityAnimation.toValue = @(endAlpha);
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    return opacityAnimation;
}

+ (CABasicAnimation *)moveYAnimationWithStartY:(CGFloat)startY endY:(CGFloat)endY {
    CABasicAnimation *moveYAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveYAnimation.fromValue = @(startY);
    moveYAnimation.toValue = @(endY);
    moveYAnimation.fillMode = kCAFillModeForwards;
    
    return moveYAnimation;
}

+ (CABasicAnimation *)moveAnimationWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    moveAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    moveAnimation.fillMode = kCAFillModeForwards;
    
    return moveAnimation;
}

+ (CABasicAnimation *)sizeAnimationWithStartSize:(CGSize)startSize endSize:(CGSize)endSize {
    CABasicAnimation *sizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    sizeAnimation.fromValue = [NSValue valueWithCGSize:startSize];
    sizeAnimation.toValue = [NSValue valueWithCGSize:endSize];
    sizeAnimation.fillMode = kCAFillModeForwards;
    
    return sizeAnimation;
}

+ (CAKeyframeAnimation *)transformAnimationWithFrameValues:(NSArray *)frameValues progressValues:(NSArray *)progressValues {
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.values = frameValues;
    transformAnimation.keyTimes = progressValues;
    
    return transformAnimation;
}

#pragma mark -

/*!
 *  Get a CAAnimationGroup
 *
 *  @param animations an array of CAAnimation objects
 *
 */
+ (CAAnimationGroup *)animationGroupWithAnimations:(NSArray *)animations {
    
    for (__unused id object in animations) {
        NSAssert([object isKindOfClass:[CAAnimation class]], @"%@ is not a CAAnimation", object);
    }
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animations;
    animationGroup.fillMode = kCAFillModeForwards;
    
    return animationGroup;
}

/*!
 *  Commit an array of CALayer's animations
 *
 *  @param layers     an array of CALayer
 *  @param animations an array of animations
 *  @param block      the block executed when all animations finished
 */
+ (void)animationWithLayers:(NSArray *)layers animations:(NSArray *)animations completion:(void (^)(void))completion {
    
    NSAssert([layers count] == [animations count], @"layers count not equal to animations");
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    
    for (NSInteger i = 0; i < [layers count]; i++) {
        CALayer *layer = layers[i];
        NSAssert([layer isKindOfClass:[CALayer class]], @"%@ is not a CALayer", layer);
        
        id animationGroupOrSingle = animations[i];
        NSAssert([animationGroupOrSingle isKindOfClass:[CAAnimationGroup class]] || [animationGroupOrSingle isKindOfClass:[CAAnimation class]], @"%@ is not a CAAnimationGroup or CAAnimation", animationGroupOrSingle);
        
        [layer addAnimation:animationGroupOrSingle forKey:nil];
    }
    
    [CATransaction commit];
}

@end
