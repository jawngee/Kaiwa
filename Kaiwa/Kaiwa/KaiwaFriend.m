//
//  KaiwaFriend.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/24/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaFriend.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "NSString+UUID.h"
#import "KaiwaHTTPRequest.h"

@interface KaiwaFriend(private)

-(void)getInfo;
-(id)parseResponse:(ASIHTTPRequest *)req;

@end


@implementation KaiwaFriend

@synthesize service, url, host, port, user, machine, app, appVersion, dispatcher, uid, outPort;

-(id)initWithService:(NSNetService *)theService dispatcher:(KaiwaDispatcher *)theDispatcher
{
	if ((self=[super init]))
	{
		dispatcher=theDispatcher;
		service=[theService retain];
		host=[[service hostName] retain];
		port=[service port];
		url=[[NSString stringWithFormat:@"http://%@:%d",[service hostName],[service port]] retain];
		
		outPort=nil;
		
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
		
		outPort=nil;
		
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
	
	[outPort release];

	[host release];
	[url release];
	
	if (user!=nil) [user release];
	if (machine!=nil) [machine release];
	if (app!=nil) [app release];
	if (appVersion!=nil) [appVersion release];
	if (uid!=nil) [uid release];
	
	[super dealloc];
}

-(void)listAddresses:(NSArray *)addressArray
{
	NSLog(@"ADDRESS COUNT %lu",[addressArray count]);
	
	for (NSData* data in addressArray) {
		
		char addressBuffer[100];
		
		struct sockaddr_in* socketAddress = (struct sockaddr_in*) [data bytes];
		
		int sockFamily = socketAddress->sin_family;
		
		if (sockFamily == AF_INET || sockFamily == AF_INET6) {
			
			const char* addressStr = inet_ntop(sockFamily,
											   &(socketAddress->sin_addr), addressBuffer,
											   sizeof(addressBuffer));
			
			int _port = ntohs(socketAddress->sin_port);
			
			if (addressStr && _port)
				NSLog(@"Found service at %s:%d", addressStr, _port);
			
		}
		
	}
}


-(void)getInfo
{
    [self ask:@"/_kaiwa/info" withData:nil forBlock:^(BOOL success, id response) {
        if (!success)
            return;
        
        NSDictionary *dict=(NSDictionary *)response;
        if (dict!=nil)
        {
            user=[[dict objectForKey:@"user"] retain];
            machine=[[dict objectForKey:@"computer"] retain];
            app=[[dict objectForKey:@"application"] retain];
            appVersion=[[dict objectForKey:@"version"] retain];
            uid=[[dict objectForKey:@"uid"] retain];
            
            BOOL hasOsc=[[dict objectForKey:@"osc"] boolValue];
            if (hasOsc)
            {
                NSInteger oscPort=[[dict objectForKey:@"osc-port"] integerValue];
                
                [self listAddresses:[service addresses]];
                
                NSArray				*addressArray = [service addresses];
                NSEnumerator		*it = [addressArray objectEnumerator];
                NSData				*data = nil;
                struct sockaddr_in	*sock = (struct sockaddr_in *)[data bytes];
                char				*charPtr = nil;
                NSString			*ipString = nil;
                
                //	find the ip address & port of the resolved service
                while ((charPtr == nil) && (data = [it nextObject]))	{
                    sock = (struct sockaddr_in *)[data bytes];
                    //	only continue if this is an IPv4 address (IPv6s resolve to 0.0.0.0)
                    if (sock->sin_family == AF_INET)	{
                        charPtr = inet_ntoa(sock->sin_addr);
                    }
                }
                //	make an nsstring from the c string of the ip address string of the resolved service
                ipString = [NSString stringWithCString:charPtr encoding:NSASCIIStringEncoding];
                
                NSLog(@"IP STRING:%@",ipString);
                
                
                NSLog(@"%@",[[service addresses] objectAtIndex:0]);
                outPort=[[OSCOutPort alloc] initWithAddress:ipString andPort:oscPort];
            }
            
            NSLog(@"user:%@",user);
            NSLog(@"machine:%@",machine);
            NSLog(@"app:%@",app);
            NSLog(@"appVersion:%@",appVersion);
            NSLog(@"UID:%@",uid);
            NSLog(@"hasOsc:%@",(hasOsc) ? @"YES":@"NO");
            NSLog(@"OscPort:%ld",[[dict objectForKey:@"osc-port"] integerValue]);
        }
    }];
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


-(void)shout:(NSString *)uri withData:(NSArray *)data
{
	OSCMessage *msg=[OSCMessage createWithAddress:uri];
	
	[msg addString:dispatcher.name];
	
	for(id datum in data)
	{
		if ([datum isKindOfClass:[NSString class]])
			[msg addString:datum];
		else if ([datum isKindOfClass:[NSNumber class]])
		{
			char what=*[datum objCType];
			
			switch(what)
			{
				case 'i':
					[msg addInt:[datum integerValue]];
					break;
				case 'f':
				case 'd':
					[msg addFloat:[datum floatValue]];
					break;
				case 'c':
					[msg addBOOL:[datum boolValue]];
					break;
			}
		}
	}
	
	[outPort sendThisMessage:msg];
}


-(id)parseResponse:(ASIHTTPRequest *)req
{
	NSError *error = [req error];
	if (error)
	{
		NSLog(@"%@",[error localizedDescription]);
		return nil;
	}

	NSDictionary *headers=[req responseHeaders];
	NSString *contentType=[headers objectForKey:@"Content-Type"];
	
	if ([contentType isEqualToString:@"application/binary"])
		return [req responseData];
#if !TARGET_OS_IPHONE
	else if ([contentType isEqualToString:@"text/xml"])
		return [[NSXMLDocument alloc] initWithData:[req responseData] options:NSXMLDocumentTidyXML error:nil];
#endif
	else if ([contentType isEqualToString:@"text/json"])
		return [[req responseString] JSONValue];
	
	return [req responseString];
}


-(id)demand:(NSString *)uri withData:(NSDictionary *)data
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

	return [self parseResponse:req];
}

-(void)ask:(NSString *)uri withData:(NSDictionary *)data forBlock:(AskBlock)askBlock
{
	NSURL *theurl=[NSURL URLWithString:[url stringByAppendingString:uri]];
	KaiwaHTTPRequest *req=nil;
	
	if (data==nil)
		req=[KaiwaHTTPRequest requestWithURL:theurl];
	else
	{
		req=[KaiwaFormDataRequest requestWithURL:theurl];
		for(NSString *key in [data allKeys])
			[(ASIFormDataRequest *)req setPostValue:[data objectForKey:key] forKey:key];
		[req setRequestMethod:@"POST"];
	}
	
	[req addRequestHeader:@"KAIWA-UID" value:dispatcher.name];
	
	[req setDelegate:self];
	[req startAsynchronous:^(BOOL success, id req){
	
		id responseData=nil;
		if (success)
			responseData=[self parseResponse:req];
		else
			responseData=[req error];
		
		askBlock(success,responseData);
	}];
}

-(void)ask:(NSString *)uri withData:(NSDictionary *)data forDelegate:(id<KaiwaAskDelegate>)delegate
{
	[self ask:uri withData:data forBlock:^(BOOL success, id response){

		if (success)
			[delegate replyFrom:self with:response];
		else
			[delegate errorFrom:self error:response];
		
	}];
}


@end