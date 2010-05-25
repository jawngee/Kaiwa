//
//  Kaiwa_Raw_TesterAppDelegate.h
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Kaiwa.h"

@interface Kaiwa_Raw_TesterAppDelegate : NSObject <NSApplicationDelegate, KaiwaControllerProtocol> {
    NSWindow *window;
	KaiwaRequest *request;
	KaiwaResponse *response;
}


@property (assign) IBOutlet NSWindow *window;


-(void)setRequest:(KaiwaRequest *)theRequest;
-(void)setResponse:(KaiwaResponse *)theResponse;

@end
