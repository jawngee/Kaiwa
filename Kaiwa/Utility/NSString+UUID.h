//
//  NSString+UUID.h
//  Shave
//
//  Created by Jon Gilkison on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString(UUID)

+(NSString *)UUID;
+(NSString *)TempPathForFile:(NSString *)fileName;

@end
