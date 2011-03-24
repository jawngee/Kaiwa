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
#import "NSString+UUID.h"

@interface KaiwaFriend(private)

-(void)getInfo;

@end


@implementation KaiwaFriend

@synthesize service, url, host, port, user, machine, app, appVersion, dispatcher, uid;

-(id)initWithService:(NSNetService *)theService dispatcher:(KaiwaDispatcher *)theDispatcher
{
	if ((self=[super init]))
	{
		dispatcher=theDispatcher;
		service=[theService retain];
		host=[[service hostName] retain];
		port=[service port];
		url=[[NSString stringWithFormat:@"http://%@:%d",[service hostName],[service port]] retain];
		
		user=nil;
		machine=nil;
		app=nil;
		appVersion=nil;
		uid=nil;
		
		[self getInfo];
	}
	
	return self;
}

-(id)initWithHost:(NSString *)theHost port:(NSInteger)thePort dispatcher:(KaiwaDispatcher *)theDispatcher
{
	if ((self=[super init]))
	{
		dispatcher=theDispatcher;
		service=nil;

		host=[theHost retain];
		port=thePort;
		url=[[NSString stringWithFormat:@"http://%@:%d",host,port] retain];
		
		user=nil;
		machine=nil;
		app=nil;
		appVersion=nil;
		uid=nil;
		
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
	if (uid!=nil) [uid release];
	
	[super dealloc];
}

-(void)getInfo
{
	NSDictionary *dict=[self ask:@"/_kaiwa/info" withData:nil];
	if (dict!=nil)
	{
		user=[[dict objectForKey:@"user"] retain];
		machine=[[dict objectForKey:@"computer"] retain];
		app=[[dict objectForKey:@"application"] retain];
		appVersion=[[dict objectForKey:@"version"] retain];
		uid=[[dict objectForKey:@"uid"] retain];
		
		NSLog(@"UID:%@",uid);
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
	
	[req addRequestHeader:@"KAIWA-UID" value:dispatcher.name];
	
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

	
	[req addRequestHeader:@"KAIWA-UID" value:dispatcher.name];
	
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