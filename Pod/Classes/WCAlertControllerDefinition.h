//
//  WCAlertControllerDefinition.h
//  Pods
//
//  Created by wesley chen on 16/2/24.
//
//

#import <Foundation/Foundation.h>

/**
 *  The callback when the WCAlertController showed or dismissed
 *
 *  @param contentViewController the ContentViewController to show as an alert
 *  @param presented             showed or dismissed
 *  @param maskViewTapped        when showed, always is NO; when dismissed, YES if background tapped, NO if call public API programmactically
 *
 *  @warning This callback will be called before viewDidAppear/viewDidDisappear method
 */
typedef void(^WCAlertControllerCompletion)(id contentViewController, BOOL presented, BOOL maskViewTapped);

/**
 *  The animation style that WCAlertController supports
 */
typedef NS_ENUM(NSUInteger, WCAlertAnimationStyle) {
    /**
     *  Just like UIAlertView
     */
    WCAlertAnimationStyleSystem,
    /**
     *  <#Description#>
     */
    WCAlertAnimationStyleBounce,
    /**
     *  <#Description#>
     */
    WCAlertAnimationStyleSlideUp,
    /**
     *  <#Description#>
     */
    WCAlertAnimationStyleSqueeze,
    /**
     *  Specify it when use customized animator that confirms WCAlertAnimator protocol
     */
    WCAlertAnimationStyleCustom,
};


