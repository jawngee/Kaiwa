//
//  KMMessageWindowController.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KaiwaFramework/Kaiwa.h>
#import "KMBuddy.h"

@interface KMMessageWindowController : NSWindowController {
	IBOutlet NSTextField *messageField;
	IBOutlet NSTextView *messagesView;
	KMBuddy *buddy;
}

-(id)initWithBuddy:(KMBuddy *)theBuddy;

-(void)receiveMessage:(NSString *)string;

-(IBAction)sendMessage:(id)sender;

@end
