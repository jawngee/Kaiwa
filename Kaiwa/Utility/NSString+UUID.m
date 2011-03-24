//
//  NSString+UUID.m
//  Shave
//
//  Created by Jon Gilkison on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+UUID.h"


@implementation NSString(UUID)

+(NSString *)UUID
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	NSString *result=[NSString stringWithFormat:@"%@",(NSString *)uuidString];
	CFRelease(uuidString);
	
	return [result autorelease];
}

+(NSString *)TempPathForFile:(NSString *)fileName
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	NSString *result=[[NSTemporaryDirectory() stringByAppendingPathComponent:(NSString *) uuidString] stringByAppendingString:fileName];
	CFRelease(uuidString);
	
	return [result autorelease];
}

@end
