//
//  WCAlertAnimator.h
//  Pods
//
//  Created by wesley chen on 16/2/25.
//
//

#import <Foundation/Foundation.h>

/**
 *  Customized animation for the alert must confirm the WCAlertAnimator protocol
 *
 *  @note the maskView (background view) use the animator's showDuration/dismissDuration if showDuration/dismissDuration properties not set in WCAlertController
 */
@protocol WCAlertAnimator <NSObject>

@property (nonatomic, assign) CGFloat showDuration;
@property (nonatomic, assign) CGFloat dismissDuration;

- (CAAnimation *)animationsForShow;
- (CAAnimation *)animationsForDismiss;

@end
