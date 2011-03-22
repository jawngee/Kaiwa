//
//  Kaiwa_Raw_TesterAppDelegate.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Kaiwa_Raw_TesterAppDelegate.h"
#import "AGRegex.h"
#import "KaiwaTestController.h"
#import "KaiwaTestPostController.h"
#import "Kaiwa.h"
#import "ASIFormDataRequest.h"

@implementation Kaiwa_Raw_TesterAppDelegate

@synthesize window,dispatcher,friends;

-(void)selectTest:(NSString*)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	friends=[[[NSMutableArray alloc] init] retain];
	ASIFormDataRequest *req=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://admin.trunkarchive.com/sweet.php"]];
	[req startSynchronous];
	NSLog(@"res: %@",[req responseString]);
	
	dispatcher=[[KaiwaDispatcher alloc] initWithType:@"_kaiwa._tcp" port:8181];
	dispatcher.delegate=self;
	
	// register the favicon
	[dispatcher registerURI:@"favicon.ico" forFile:[[NSBundle mainBundle] pathForResource:@"kaiwa_16" ofType:@"ico"]];
	
	// register a "resource" path
	[dispatcher registerURI:@"/res" forPath:[[NSBundle mainBundle] resourcePath]];
	
	// set the index file
	[dispatcher registerURI:@"/" forFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
	
	// register the command interface
	[dispatcher registerRoute:@"/command/(.*)" forInstance:self];
	
	// set the index file
	[dispatcher registerURI:@"/post" forFile:[[NSBundle mainBundle] pathForResource:@"post" ofType:@"html"]];

	// register the command interface
	[dispatcher registerRoute:@"/post/(.*)"  forClass:[KaiwaTestPostController class] persistInstance:YES];

	[dispatcher start];
	
	[dispatcher findFriends];
}

-(void)foundFriend:(KaiwaFriend *)newFriend
{
	[arrayController addObject:newFriend];
	
	NSLog(@"Found friend:%@",newFriend.url);
}

-(void)lostFriend:(KaiwaFriend *)oldFriend
{
	NSLog(@"Lost friend:%@",oldFriend.url);
	[arrayController removeObject:oldFriend];
}

-(void)defaultAction
{
	[response writeLine:@"default"];
}

-(void)updateAction
{
	HTTPCookie *cookie=[request.cookies objectForKey:@"hello"];
	
	if (cookie==nil)
	{
		[response addCookie:[[HTTPCookie alloc] initWithName:@"hello" value:@"there" expiresIn:600]];
		[response writeLine:@"happy"];
	}
	else
	{
		[response writeLine:cookie.value];
	}
	
}

-(void)labelAction
{
	[response writeLine:[request.query objectForKey:@"label"]];
}

-(void)setRequest:(KaiwaRequest *)theRequest
{
	request=[theRequest retain];
}

-(void)setResponse:(KaiwaResponse *)theResponse
{
	response=[theResponse retain];
}

@end