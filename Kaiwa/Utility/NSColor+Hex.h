//
//  NSColor+Hex.h
//  KaiwaFramework
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#if TARGET_OS_IPHONE
@interface UIColor(HEX) 
#else
@interface NSColor(HEX) 
#endif

-(NSString *)hexColorString;

#if TARGET_OS_IPHONE
+(UIColor *)colorFromHexString:(NSString*)hex;
#else
+(NSColor *)colorFromHexString:(NSString*)hex;
#endif

@end
