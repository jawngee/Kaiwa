//
//  NSString+UUID.h
//  Shave
//
//  Created by Jon Gilkison on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


@interface NSString(UUID)

+(NSString *)UUID;
+(NSString *)TempPathForFile:(NSString *)fileName;

@end
