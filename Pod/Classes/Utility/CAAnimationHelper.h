//
//  CAAnimationHelper.h
//  CAAnimationHelper
//
//  Created by wesley_chen on 15/1/25.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

// The recommended time for animation
#define kAnimationDuration 0.3

@class CABasicAnimation;

@interface CAAnimationHelper : NSObject

// Get specific animations
+ (CABasicAnimation *)opacityAnimationWithStartAlpha:(CGFloat)startAlpha endAlpha:(CGFloat)endAlpha;

+ (CABasicAnimation *)moveYAnimationWithStartY:(CGFloat)startY endY:(CGFloat)endY;
+ (CABasicAnimation *)moveAnimationWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
+ (CABasicAnimation *)sizeAnimationWithStartSize:(CGSize)startSize endSize:(CGSize)endSize;

+ (CAKeyframeAnimation *)transformAnimationWithFrameValues:(NSArray *)frameValues progressValues:(NSArray *)progressValues;

// Group animations
+ (CAAnimationGroup *)animationGroupWithAnimations:(NSArray *)animations;

// Excute animations
+ (void)animationWithLayers:(NSArray *)layers animations:(NSArray *)animationGroups completion:(void (^)(void))completion;

@end
