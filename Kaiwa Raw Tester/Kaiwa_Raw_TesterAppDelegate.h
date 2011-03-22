//
//  Kaiwa_Raw_TesterAppDelegate.h
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Kaiwa.h"

@interface Kaiwa_Raw_TesterAppDelegate : NSObject <NSApplicationDelegate, KaiwaControllerProtocol, KaiwaDispatcherProtocol> 
{
	NSWindow *window;
	KaiwaRequest *request;
	KaiwaResponse *response;
	
	KaiwaDispatcher *dispatcher;
	
	NSMutableArray *friends;
	
	IBOutlet NSArrayController *arrayController;
}


@property (assign) IBOutlet NSWindow *window;
@property (readonly)  KaiwaDispatcher *dispatcher;
@property (readonly)  NSMutableArray *friends;


-(void)setRequest:(KaiwaRequest *)theRequest;
-(void)setResponse:(KaiwaResponse *)theResponse;

@end