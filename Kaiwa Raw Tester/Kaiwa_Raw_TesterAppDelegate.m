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

@implementation Kaiwa_Raw_TesterAppDelegate

@synthesize window;

-(void)selectTest:(NSString*)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// register the favicon
	[KaiwaDispatcher registerURI:@"favicon.ico" forFile:[[NSBundle mainBundle] pathForResource:@"kaiwa_16" ofType:@"ico"]];
	
	// register a "resource" path
	[KaiwaDispatcher registerURI:@"/res" forPath:[[NSBundle mainBundle] resourcePath]];
	
	// set the index file
	[KaiwaDispatcher registerURI:@"/" forFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
	
	// register the command interface
	[KaiwaDispatcher registerRoute:@"/command/(.*)" forInstance:self];
	
	[KaiwaDispatcher start];
}

-(void)defaultAction
{
	[response writeLine:@"default"];
}

-(void)updateAction
{
	[response writeLine:@"happy"];
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
