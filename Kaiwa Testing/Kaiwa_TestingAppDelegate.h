//
//  Kaiwa_TestingAppDelegate.h
//  Kaiwa Testing
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Kaiwa/Kaiwa.h>

@interface Kaiwa_TestingAppDelegate : NSObject <NSApplicationDelegate, KaiwaControllerProtocol> 
{
    NSWindow *window;
	KaiwaRequest *request;
	KaiwaResponse *response;
	
	IBOutlet NSTextField *whee;
}


@property (assign) IBOutlet NSWindow *window;


-(void)setRequest:(KaiwaRequest *)theRequest;
-(void)setResponse:(KaiwaResponse *)theResponse;


@end
