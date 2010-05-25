//
//  Kaiwa_TestingAppDelegate.m
//  Kaiwa Testing
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Kaiwa_TestingAppDelegate.h"

@implementation Kaiwa_TestingAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	[KaiwaDispatcher registerURI:@"favicon.ico" forFile:[[NSBundle mainBundle] pathForResource:@"kaiwa_16" ofType:@"ico"]];
	[KaiwaDispatcher registerURI:@"/res" forPath:[[NSBundle mainBundle] resourcePath]];
	[KaiwaDispatcher registerURI:@"/" forFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
	
	[KaiwaDispatcher registerRoute:@"/update" forInstance:self andSelector:@selector(updateAction)];
	
	[KaiwaDispatcher start];
}

-(void)updateAction
{
	[whee setStringValue:@"HELLO NICK!"];
}

-(void)helloWorld
{
	[response writeLine:@"Hello World!"];
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
