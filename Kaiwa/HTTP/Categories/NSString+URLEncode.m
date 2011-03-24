//
//  NSString+URLEncode.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "NSString+URLEncode.h"


@implementation NSString(URLEncode)


-(NSString *)urlEncoded
{
	return [NSString stringWithString: (NSString *)
			 CFURLCreateStringByAddingPercentEscapes(
													 NULL, 
													 (CFStringRef)self,
													 NULL, 
													 (CFStringRef)@";/?:@&=+$,",
													 kCFStringEncodingUTF8)];
}

-(NSString *)urlDecoded
{
	return [NSString stringWithString:(NSString *)
			CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)self, (CFStringRef)@"", kCFStringEncodingUTF8)];
}

@end
