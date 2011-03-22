//
//  KaiwaFriend.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KaiwaFriend.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface KaiwaFriend(private)

-(void)getInfo;

@end


@implementation KaiwaFriend

@synthesize service, url, host, port, user, machine, app, appVersion;

-(id)initWithService:(NSNetService *)theService
{
	if ((self=[super init]))
	{
		service=[theService retain];
		host=[[service hostName] retain];
		port=[service port];
		url=[[NSString stringWithFormat:@"http://%@:%d",[service hostName],[service port]] retain];
		
		user=nil;
		machine=nil;
		app=nil;
		appVersion=nil;
		
		[self getInfo];
	}
	
	return self;
}

-(id)initWithHost:(NSString *)theHost port:(NSInteger)thePort
{
	if ((self=[super init]))
	{
		service=nil;

		host=[theHost retain];
		port=thePort;
		url=[[NSString stringWithFormat:@"http://%@:%d",host,port] retain];

		user=nil;
		machine=nil;
		app=nil;
		appVersion=nil;
		
		[self getInfo];
	}
	
	return self;
}

-(void)dealloc
{
	if (service!=nil)	[service release];

	[host release];
	[url release];
	
	if (user!=nil) [user release];
	if (machine!=nil) [machine release];
	if (app!=nil) [app release];
	if (appVersion!=nil) [appVersion release];
	
	[super dealloc];
}

-(void)getInfo
{
	NSDictionary *dict=[self ask:@"/_kaiwa/info" withData:nil];
	if (dict!=nil)
	{
		user=[dict objectForKey:@"user"];
		if (user!=nil) [user retain];
		
		machine=[dict objectForKey:@"computer"];
		if (machine!=nil) [machine retain];

		app=[dict objectForKey:@"application"];
		if (app!=nil) [app retain];

		appVersion=[dict objectForKey:@"version"];
		if (appVersion!=nil) [appVersion retain];
	}
}

-(void)tell:(NSString *)uri withData:(NSDictionary *)data
{
	NSURL *theurl=[NSURL URLWithString:[url stringByAppendingString:uri]];
	ASIHTTPRequest *req=nil;
	
	if (data==nil)
		req=[ASIHTTPRequest requestWithURL:theurl];
	else
	{
		req=[ASIFormDataRequest requestWithURL:theurl];
		for(NSString *key in [data allKeys])
			[(ASIFormDataRequest *)req setPostValue:[data objectForKey:key] forKey:key];
		[req setRequestMethod:@"POST"];
	}
	
	[req startAsynchronous];
}

-(id)ask:(NSString *)uri withData:(NSDictionary *)data
{
	NSURL *theurl=[NSURL URLWithString:[url stringByAppendingString:uri]];
	ASIHTTPRequest *req=nil;
	
	if (data==nil)
		req=[ASIHTTPRequest requestWithURL:theurl];
	else
	{
		req=[ASIFormDataRequest requestWithURL:theurl];
		for(NSString *key in [data allKeys])
			[(ASIFormDataRequest *)req setPostValue:[data objectForKey:key] forKey:key];
		[req setRequestMethod:@"POST"];
	}

	[req startSynchronous];
	NSError *error = [req error];
	if (error)
	{
		NSLog(@"%@",[error localizedDescription]);
		return nil;
	}

	NSDictionary *headers=[req responseHeaders];
	NSString *contentType=[headers objectForKey:@"Content-Type"];
	
	if ([contentType isEqualToString:@"text/xml"])
		return [[NSXMLDocument alloc] initWithData:[req responseData] options:NSXMLDocumentTidyXML error:nil];
	else if ([contentType isEqualToString:@"text/json"])
		return [[req responseString] JSONValue];
	
	return [req responseString];
}



@end