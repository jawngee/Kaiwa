//
//  NSDictionary+URLEncode.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "NSDictionary+URLEncode.h"
#import "NSString+URLEncode.h"

@implementation NSDictionary(URLEncode)

-(NSString*) urlEncoded
{
	NSMutableArray *parts = [NSMutableArray array];
	for (NSString *key in self) 
	{
		id value = [self objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", 
						  [key urlEncoded], [[NSString stringWithFormat:@"%@",value] urlEncoded]];
		[parts addObject: part];
	}
	
	return [parts componentsJoinedByString: @"&"];
}


+(NSDictionary *)parsedQuery:(NSString *)queryString
{
	NSMutableDictionary *result=[NSMutableDictionary dictionary];
	NSArray *parts=[queryString componentsSeparatedByString:@"&"];
	for(NSString *pair in parts)
	{
		NSArray *values=[pair componentsSeparatedByString:@"="];
		if ([values count]==1)
			[result setObject:@"YES" forKey:[[values objectAtIndex:0] urlDecoded]];
		else if ([values count]==2)
			[result setObject:[[values objectAtIndex:1] urlDecoded] forKey:[[values objectAtIndex:0] urlDecoded]];
	}
	
	return result;
}

@end
