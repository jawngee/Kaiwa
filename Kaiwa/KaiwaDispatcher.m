//
//  KaiwaDispatcher.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaDispatcher.h"
#import "KaiwaRoute.h"
#import "KaiwaRewrite.h"
#import "KaiwaFilePath.h"
#import "KaiwaConnection.h"

#import "ThreadPoolServer.h"
#import "ThreadPerConnectionServer.h"
#import "HTTPAsyncFileResponse.h"
#import "HTTPConnection.h"

@interface KaiwaDispatcher(private)

-(void)doRegisterRewrite:(NSString *)fromRegex to:(NSString *)replacement;

-(void)doRegisterRoute:(NSString *)route forInstance:(id)theInstance;
-(void)doRegisterRoute:(NSString *)route forInstance:(id)theInstance andSelector:(SEL)theSelector;
-(void)doRegisterRoute:(NSString *)route forClass:(Class)theClass persistInstance:(BOOL)isPersistant;
-(void)doRegisterRoute:(NSString *)route forClass:(Class)theClass andSelector:(SEL)theSelector persistInstance:(BOOL)isPersistant;

-(void)doRegisterURI:(NSString *)uri forFile:(NSString *)theFile;
-(void)doRegisterURI:(NSString *)uri forPath:(NSString *)thePath;

-(void)doStart;
-(void)doStop;

-(void)setName:(NSString *)theName;
-(void)setType:(NSString *)theType;
-(void)setPort:(NSInteger)thePort;

-(NSObject<HTTPResponse> *)doDispatch:(NSString*)uri forMethod:(NSString *)method withConnection:(HTTPConnection *)connection;

-(void)setFriendFinderDelegate:(id<KaiwaFinderProtocol>)finder;
-(void)doFindFriends;


@end


@implementation KaiwaDispatcher

static KaiwaDispatcher *dispatcher = nil;

+(KaiwaDispatcher *)dispatcher
{
    @synchronized(self)
    {
        if (dispatcher == nil)
			dispatcher = [[KaiwaDispatcher alloc] init];
    }
    return dispatcher;
}

-(id)init
{
	if ((self=[super init]))
	{
		routes=[[NSMutableArray array] retain];
		filePaths=[[NSMutableArray array] retain];
		rewrites=[[NSMutableArray array] retain];
		port=8181;
		name=[@"Kaiwa" retain];
		type=[@"_http._tcp" retain];
		httpServer=nil;
		
		serviceBrowser=nil;
		friendFinder=nil;
		
		friends=[NSMutableArray array];
		friendServices=[NSMutableArray array];
	}
	
	return self;
}

#pragma mark static route methods

+(void)registerRewrite:(NSString *)fromRegex to:(NSString *)replacement
{
	[[KaiwaDispatcher dispatcher] doRegisterRewrite:fromRegex to:replacement];
}

+(void)registerRoute:(NSString *)route forInstance:(id)theInstance
{
	[[KaiwaDispatcher dispatcher] doRegisterRoute:route forInstance:theInstance];
}

+(void)registerRoute:(NSString *)route forInstance:(id)theInstance andSelector:(SEL)theSelector
{
	[[KaiwaDispatcher dispatcher] doRegisterRoute:route forInstance:theInstance andSelector:theSelector];
}

+(void)registerRoute:(NSString *)route forClass:(Class)theClass persistInstance:(BOOL)isPersistant
{
	[[KaiwaDispatcher dispatcher] doRegisterRoute:route forClass:theClass persistInstance:isPersistant];
}

+(void)registerRoute:(NSString *)route forClass:(Class)theClass andSelector:(SEL)theSelector persistInstance:(BOOL)isPersistant
{
	[[KaiwaDispatcher dispatcher] doRegisterRoute:route forClass:theClass andSelector:theSelector persistInstance:isPersistant];
}

+(void)registerURI:(NSString *)uri forFile:(NSString *)theFile
{
	[[KaiwaDispatcher dispatcher] doRegisterURI:uri forFile:theFile];
}

+(void)registerURI:(NSString *)uri forPath:(NSString *)thePath
{
	[[KaiwaDispatcher dispatcher] doRegisterURI:uri forPath:thePath];
}

#pragma mark private methods

-(void)doRegisterRewrite:(NSString *)fromRegex to:(NSString *)replacement
{
	[rewrites addObject:[[KaiwaRewrite alloc] initWithRewrite:fromRegex to:replacement]];
}

-(void)doRegisterRoute:(NSString *)route forInstance:(id)theInstance
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forInstance:theInstance]];
}

-(void)doRegisterRoute:(NSString *)route forInstance:(id)theInstance andSelector:(SEL)theSelector
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forInstance:theInstance andSelector:theSelector]];
}

-(void)doRegisterRoute:(NSString *)route forClass:(Class)theClass persistInstance:(BOOL)isPersistant
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forClass:theClass persistInstance:isPersistant]];
}

-(void)doRegisterRoute:(NSString *)route forClass:(Class)theClass andSelector:(SEL)theSelector persistInstance:(BOOL)isPersistant
{
	[routes addObject:[[KaiwaRoute alloc] initWithRoute:route forClass:theClass andSelector:theSelector persistInstance:isPersistant]];
}

-(void)doRegisterURI:(NSString *)uri forFile:(NSString *)theFile
{
	[filePaths addObject:[[KaiwaFilePath alloc] initWithURIBase:uri forPath:theFile isFile:YES]];
}

-(void)doRegisterURI:(NSString *)uri forPath:(NSString *)thePath
{
	[filePaths addObject:[[KaiwaFilePath alloc] initWithURIBase:uri forPath:thePath isFile:NO]];
}

-(void)setFriendFinderDelegate:(id<KaiwaFinderProtocol>)finder
{
	friendFinder=finder;
}

-(void)doFindFriends
{
	serviceBrowser=[[NSNetServiceBrowser alloc] init];
	serviceBrowser.delegate=self;
	[serviceBrowser searchForServicesOfType:type inDomain:@""];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more 
{
	[friendServices addObject:aService];
	
	aService.delegate=self;
	[aService resolveWithTimeout:0];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more 
{
	[serviceBrowser removeObject:aService];
	
	for(KaiwaFriend *friend in friends)
		if (friend.service==aService)
		{
			[friends removeObject:friend];
			
			if (friendFinder!=nil)
				[friendFinder lostFriend:friend];

			break;
		}
}

-(void)netServiceDidResolveAddress:(NSNetService *)aService 
{
	KaiwaFriend *friend=[[KaiwaFriend alloc] initWithService:aService];
	
	[friend addObject:friend];
	
	if (friendFinder!=nil)
		[friendFinder foundFriend:friend];
}



#pragma mark Server control

+(void)start
{
	[[KaiwaDispatcher dispatcher] doStart];
}

+(void)startWithName:(NSString *)theName andType:(NSString *)theType atPort:(NSInteger)thePort
{
	[[KaiwaDispatcher dispatcher] setName:theName];
	[[KaiwaDispatcher dispatcher] setType:theType];
	[[KaiwaDispatcher dispatcher] setPort:thePort];

	[[KaiwaDispatcher dispatcher] doStart];
}

+(void)stop
{
	[[KaiwaDispatcher dispatcher] doStop];
}

-(void)setName:(NSString *)theName
{
	name=[theName retain];
}

-(void)setType:(NSString *)theType
{
	type=[theType retain];
}

-(void)setPort:(NSInteger)thePort
{
	port=thePort;
}

-(void)doStart
{
	if (httpServer!=nil)
		[self doStop];
	
	httpServer = [[[ThreadPoolServer alloc] init] retain];
	
	[httpServer setName:name];
	[httpServer setType:type];
	[httpServer setPort:port];
	[httpServer setConnectionClass:[KaiwaConnection class]];
//	[httpServer setDocumentRoot:[NSURL fileURLWithPath:[@"~/DropBox/Projects/control_apps/" stringByExpandingTildeInPath]]];
	
	NSError *error;
	BOOL success = [httpServer start:&error];
	
	if(!success)
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
	
}

-(void)doStop
{
	if (httpServer!=nil)
	{
		[httpServer stop];
		[httpServer release];
		httpServer=nil;
	}
}

#pragma mark dispatch

+(NSObject<HTTPResponse> *)dispatch:(NSString*)uri forMethod:(NSString *)method withConnection:(KaiwaConnection *)connection
{
	return [[KaiwaDispatcher dispatcher] doDispatch:uri forMethod:method withConnection:connection];
}

-(NSObject<HTTPResponse> *)doDispatch:(NSString*)uri forMethod:(NSString *)method withConnection:(KaiwaConnection *)connection
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
	KaiwaResponse *res=[[KaiwaResponse alloc] initWithConnection:connection];
	for(KaiwaRoute *route in routes)
		if ([route invoke:req forResponse:res])
			return [res httpResponse];
	
	return nil;
}

#pragma mark singleton stuff

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (dispatcher == nil) {
            dispatcher = [super allocWithZone:zone];
            return dispatcher;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end
