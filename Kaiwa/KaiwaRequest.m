//
//  KaiwaRequest.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaRequest.h"
#import "KaiwaConnection.h"
#import "NSString+URLEncode.h"

@implementation KaiwaRequest

@synthesize args, headers, cookies, query, method, uri, url;

#pragma mark initialization

-(id)initWithURIString:(NSString*)uriString forMethod:(NSString *)theMethod withConnection:(KaiwaConnection *)theConnection
{
	if ((self=[super init]))
	{
		connection=theConnection;
		
		uri=[uriString retain];
		method=[theMethod retain];
		url=[[[NSURL alloc] initWithScheme:@"http" host:@"localhost" path:uriString] retain];
		query=[[[NSMutableDictionary alloc] init] retain];
		
		NSArray *paramParts=[uriString componentsSeparatedByString:@"?"];
		if ([paramParts count]>1)
		{
			NSArray *parameters=[[paramParts objectAtIndex:1] componentsSeparatedByString:@"&"];
			for(NSString *param in parameters)
			{
				NSArray *elements=[param componentsSeparatedByString:@"="];
				if ([elements count]==1)
					[query setObject:@"YES" forKey:[[elements objectAtIndex:0] urlDecoded]];
				else if ([elements count]==2)
					[query setObject:[[elements objectAtIndex:1] urlDecoded] forKey:[[elements objectAtIndex:0] urlDecoded]];
			}
		}
		args=nil;
	}
	
	return self;
}

-(void)dealloc
{
	[uri release];
	[method release];
	[query release];
	[url release];
	
	[super dealloc];
}

@end
