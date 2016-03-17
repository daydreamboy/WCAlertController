//
//  WCAlertControllerMacro.h
//  Pods
//
//  Created by wesley chen on 16/2/24.
//
//

#ifndef WCAlertControllerMacro_h
#define WCAlertControllerMacro_h

// Screen Width
#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#endif

// Screen Height
#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#endif

#ifndef BLOCK_SAFE_RUN
#define BLOCK_SAFE_RUN(block, ...) \
    do {                           \
        if (block) {               \
            block(__VA_ARGS__);    \
        }                          \
    } while (0)
#endif /* BLOCK_SAFE_RUN */

// >= `9.0`
#ifndef IOS9_OR_LATER
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
#endif


#endif /* WCAlertControllerMacro_h */
