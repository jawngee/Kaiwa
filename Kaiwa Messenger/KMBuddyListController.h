//
//  KMBuddyListController.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Kaiwa.h"


@interface KMBuddyListController : NSObject<KaiwaDispatcherProtocol> {
	KaiwaRequest *request;
	KaiwaResponse *response;
	
	KaiwaDispatcher *dispatcher;
	
	IBOutlet NSArrayController *friendsArrayController;
}

-(IBAction)doubleClick:(id)sender;
-(IBAction)statusChanged:(id)sender;

@end
