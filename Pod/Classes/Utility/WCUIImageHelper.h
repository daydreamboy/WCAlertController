//
//  UIImageHelper.h
//  Pods
//
//  Created by wesley chen on 16/3/2.
//
//

#import <Foundation/Foundation.h>

// Prefine blur style
typedef NS_ENUM(NSUInteger, WCImageBlurStyle) {
    WCImageBlurStyleOriginal,
    WCImageBlurStyleLight,
    WCImageBlurStyleExtraLight,
    WCImageBlurStyleDark,
};

@interface WCUIImageHelper : NSObject

+ (UIImage *)blurredImageWithImage:(UIImage *)image imageBlurStyle:(WCImageBlurStyle)style;
+ (UIImage *)blurredImageWithImage:(UIImage *)image tintColor:(UIColor *)tintColor maskColor:(UIColor *)maskColor;

@end
