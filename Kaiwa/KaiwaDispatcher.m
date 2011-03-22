//
//  KaiwaDispatcher.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "RandomSequence.h"

#import "KaiwaDispatcher.h"
#import "KaiwaRoute.h"
#import "KaiwaRewrite.h"
#import "KaiwaFilePath.h"
#import "KaiwaConnection.h"
#import "KaiwaHTTPServer.h"
#import "KaiwaFriend.h"
#import "KaiwaFriendController.h"

#import "ThreadPoolServer.h"
#import "ThreadPerConnectionServer.h"
#import "HTTPAsyncFileResponse.h"
#import "HTTPConnection.h"


@implementation KaiwaDispatcher

#pragma mark property synthesizer

@synthesize routes, rewrites, filePaths, name, type, port, delegate, friends;

#pragma mark initialization/dealloc

-(id)initWithType:(NSString *)theType port:(NSInteger)thePort
{
	if ((self=[super init]))
	{
		routes=[[NSMutableArray array] retain];
		filePaths=[[NSMutableArray array] retain];
		rewrites=[[NSMutableArray array] retain];
		
		port=thePort;
		type=[theType retain];
		
		httpServer=nil;
		
		serviceBrowser=nil;
		delegate=nil;
		
		friends=[[NSMutableArray array] retain];
		friendServices=[[NSMutableArray array] retain];
		
		CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
		//get the string representation of the UUID
		NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
		CFRelease(uuidObj);
		
		name=[uuidString retain];
		NSLog(@"name: %@",name);
		
		[self registerRoute:@"/_kaiwa/(.*)" forClass:[KaiwaFriendController class] persistInstance:YES];
	}
	
	return self;
}

-(void)dealloc
{
	[self stop];
	
	[routes release];
	[filePaths release];
	[rewrites release];
	
	[name release];
	[type release];
	
	if (serviceBrowser!=nil)
		[serviceBrowser release];
	
	[friends release];
	[friendServices release];
	
	[super dealloc];
}


#pragma mark route methods

-(void)registerRewrite:(NSString *)fromRegex to:(NSString *)replacement
{
	[rewrites addObject:[[KaiwaRewrite alloc] initWithRewrite:fromRegex to:replacement]];
}

-(void)registerRoute:(NSString *)route forInstance:(id)theInstance
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forInstance:theInstance]];
}

-(void)registerRoute:(NSString *)route forInstance:(id)theInstance andSelector:(SEL)theSelector
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forInstance:theInstance andSelector:theSelector]];
}

-(void)registerRoute:(NSString *)route forClass:(Class)theClass persistInstance:(BOOL)isPersistant
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forClass:theClass persistInstance:isPersistant]];
}

-(void)registerRoute:(NSString *)route forClass:(Class)theClass andSelector:(SEL)theSelector persistInstance:(BOOL)isPersistant
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forClass:theClass andSelector:theSelector persistInstance:isPersistant]];
}

-(void)registerURI:(NSString *)uri forFile:(NSString *)theFile
{
	[filePaths addObject:[[KaiwaFilePath alloc] initWithURIBase:uri forPath:theFile isFile:YES]];
}

-(void)registerURI:(NSString *)uri forPath:(NSString *)thePath
{
	[filePaths addObject:[[KaiwaFilePath alloc] initWithURIBase:uri forPath:thePath isFile:NO]];
}

#pragma mark friend finder

-(void)findFriends
{
	serviceBrowser=[[NSNetServiceBrowser alloc] init];
	serviceBrowser.delegate=self;
	[serviceBrowser searchForServicesOfType:type inDomain:@""];
}

-(void)broadcastToFriends:(NSString*)uri data:(NSDictionary *)theData
{
	for(KaiwaFriend *friend in friends)
		[friend tell:uri withData:theData];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more 
{
	if ([[aService name] isEqualToString:name])
		return;
	
	NSLog(@"found service %@",[aService name]);
	NSLog(@"found: %d",aService);
	[friendServices addObject:aService];
	
	aService.delegate=self;
	[aService resolveWithTimeout:0];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more 
{
	[friendServices removeObject:aService];
	
	NSString *url=[NSString stringWithFormat:@"http://%@:%d",[aService hostName],[aService port]];
	NSLog(@"losing: %@",url);
	
	for(KaiwaFriend *friend in friends)
	{
		NSLog(@"friend: %d",friend.service);
		NSLog(@"remove: %d",aService);
		NSLog(@"remove: %@",[[friend.service TXTRecordData] description]);
		NSLog(@"remove: %@",[[aService TXTRecordData] description]);
		
		if ([friend.service isEqual:aService])
		{
			NSLog(@"removed service");
			[friends removeObject:friend];
			
			if (delegate!=nil)
				[delegate lostFriend:friend];
			
			break;
		}
	}
}

-(void)netServiceDidResolveAddress:(NSNetService *)aService 
{
	NSLog(@"resolved friend");
	NSLog(@"resolved: %d",aService);
	
	KaiwaFriend *friend=[[KaiwaFriend alloc] initWithService:aService];
	
	[friends addObject:friend];
	
	if (delegate!=nil)
		[delegate foundFriend:friend];
}



#pragma mark Server control

-(void)startWithName:(NSString *)theName andType:(NSString *)theType atPort:(NSInteger)thePort
{
	name=[theName retain];
	type=[theType retain];
	port=thePort;
	
	[self start];
}


-(void)start
{
	if (httpServer!=nil)
		[self stop];
	
	httpServer = [[[KaiwaHTTPServer alloc] initWithDispatcher:self] retain];
	
	port=[RandomSequence randomValueBetweenLowerValue:8000 andUpperValue:9000];
	
	[httpServer setName:name];
	[httpServer setType:type];
	[httpServer setPort:port];
	[httpServer setConnectionClass:[KaiwaConnection class]];
	//	[httpServer setDocumentRoot:[NSURL fileURLWithPath:[@"~/DropBox/Projects/control_apps/" stringByExpandingTildeInPath]]];
	
	NSError *error;
	BOOL success = [httpServer start:&error];
	
	while(!success)
	{
		port=[RandomSequence randomValueBetweenLowerValue:8000 andUpperValue:9000];
		
		[httpServer setPort:port];
		success = [httpServer start:&error];
		
		NSLog(@"Error starting HTTP Server: %@", error);
	}
	
}

-(void)stop
{
	if (httpServer!=nil)
	{
		[httpServer stop];
		[httpServer release];
		httpServer=nil;
	}
}

#pragma mark dispatch

-(NSObject<HTTPResponse> *)dispatch:(NSString*)uri forMethod:(NSString *)method withConnection:(KaiwaConnection *)connection postData:(NSDictionary *)postData
{
	for(KaiwaRewrite *rewrite in rewrites)
		uri=[rewrite rewrite:uri];
	
	for(KaiwaFilePath *fpath in filePaths)
	{
		NSString *fullPath=nil;
		if ((fullPath=[fpath exists:uri])!=nil)
		{
			NSLog(@"fp: %@",fullPath);
			return [[[HTTPAsyncFileResponse alloc] initWithFilePath:fullPath forConnection:connection runLoopModes:[connection.asyncSocket runLoopModes]] autorelease];
		}
	}
	
	KaiwaRequest *req=[[KaiwaRequest alloc] initWithURIString:uri forMethod:method withConnection:connection];
	if (postData!=nil)
		[req.query addEntriesFromDictionary:postData];
	[req.cookies addEntriesFromDictionary:connection.cookies];
	
	KaiwaResponse *res=[[KaiwaResponse alloc] initWithConnection:connection];
	for(KaiwaRoute *route in routes)
		if ([route invoke:req forResponse:res])
			return [res httpResponse];
	
	return nil;
}


@end