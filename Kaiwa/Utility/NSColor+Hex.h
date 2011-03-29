//
//  NSColor+Hex.h
//  KaiwaFramework
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor(HEX) 

-(NSString *)hexColorString;
+(NSColor *)colorFromHexString:(NSString*)hex;

@end
