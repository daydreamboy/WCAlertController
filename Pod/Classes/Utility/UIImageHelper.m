//
//  UIImageHelper.m
//  Pods
//
//  Created by wesley chen on 16/3/2.
//
//

#import "UIImageHelper.h"

#import <Accelerate/Accelerate.h>

@implementation UIImageHelper

+ (UIImage *)blurredImageWithImage:(UIImage *)image imageBlurStyle:(WCImageBlurStyle)style {
    UIColor *tintColor = [UIColor colorWithWhite:0.0 alpha:0.2];

    switch (style) {
        case WCImageBlurStyleOriginal:
        default: {
            UIColor *clearColor = [UIColor clearColor];
            return [self blurredImageWithImage:image tintColor:tintColor maskColor:clearColor];
        }

        case WCImageBlurStyleLight: {
            UIColor *ligthColor = [UIColor colorWithWhite:1.0 alpha:0.3];
            return [self blurredImageWithImage:image tintColor:tintColor maskColor:ligthColor];

            break;
        }

        case WCImageBlurStyleExtraLight: {
            UIColor *extraLigthColor = [UIColor colorWithWhite:0.97 alpha:0.82];
            return [self blurredImageWithImage:image tintColor:tintColor maskColor:extraLigthColor];

            break;
        }

        case WCImageBlurStyleDark: {
            UIColor *darkColor = [UIColor colorWithWhite:0.11 alpha:0.73];
            return [self blurredImageWithImage:image tintColor:tintColor maskColor:darkColor];

            break;
        }
    }
}

+ (UIImage *)blurredImageWithImage:(UIImage *)image tintColor:(UIColor *)tintColor maskColor:(UIColor *)maskColor {
    const CGFloat tintColorAlpha = 0.6;
    const CGFloat maskColorAlpha = 0.3;

    UIColor *tintColor2 = tintColor;
    UIColor *maskColor2 = maskColor;

    if (tintColor && CGColorGetAlpha(tintColor.CGColor) == 1.0f) {
        tintColor2 = [tintColor colorWithAlphaComponent:tintColorAlpha];
    }

    if (maskColor && CGColorGetAlpha(maskColor.CGColor) == 1.0f) {
        maskColor2 = [maskColor colorWithAlphaComponent:maskColorAlpha];
    }

    const CGFloat radius = 8.0f;
    const CGFloat iterations = 8.0f;

    return [self blurredImageWithImage:image radius:radius iterations:iterations tintColor:tintColor2 maskColor:maskColor2];
}

// @sa https://github.com/nicklockwood/FXBlurView
+ (UIImage *)blurredImageWithImage:(UIImage *)image
                            radius:(CGFloat)radius
                        iterations:(NSUInteger)iterations
                         tintColor:(UIColor *)tintColor
                         maskColor:(UIColor *)maskColor {
    // image must be nonzero size
    if (floorf(image.size.width) * floorf(image.size.height) <= 0.0f) {
        return image;
    }

    // boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * image.scale);

    if (boxSize % 2 == 0) {
        boxSize++;
    }

    // create image buffers
    CGImageRef imageRef = image.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);

    // create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));

    // copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);

    for (NSUInteger i = 0; i < iterations; i++) {
        // perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

        // swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }

    // free buffers
    free(buffer2.data);
    free(tempBuffer);

    // create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));

    // apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f) {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }

    // apply mask
    if (maskColor && CGColorGetAlpha(maskColor.CGColor) > 0.0f) {
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, maskColor.CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
        CGContextRestoreGState(ctx);
    }

    // create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *outputImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return outputImage;
}

@end
