//
//  KMMessageWindowController.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KMMessageWindowController.h"


@implementation KMMessageWindowController


-(id)initWithBuddy:(KMBuddy *)theBuddy
{
	if (self=[super initWithWindowNibName:[self className]])
	{
		buddy=[theBuddy retain];
	}
	
	return self;
}

-(void)dealloc
{
	[buddy release];
	[super dealloc];
}

-(void)windowDidLoad
{
	[super windowDidLoad];
	
	[[self window] setTitle:[NSString stringWithFormat:@"Conversation with %@",buddy.userName]];
}


-(void)receiveMessage:(NSString *)string
{
	[[[messagesView textStorage] mutableString] appendString: [NSString stringWithFormat:@"%@\n",string]];
	
	NSRange range = NSMakeRange ([[messagesView string] length], 0);
	
    [messagesView scrollRangeToVisible: range];
}

-(IBAction)sendMessage:(id)sender
{
	[[[messagesView textStorage] mutableString] appendString: [NSString stringWithFormat:@"%@\n",[messageField stringValue]]];
	
	NSRange range = NSMakeRange ([[messagesView string] length], 0);
	
    [messagesView scrollRangeToVisible: range];

	[buddy.friend tell:@"/command/message" withData:[NSMutableDictionary dictionaryWithObjectsAndKeys:[messageField stringValue],@"message",nil]];
	[messageField setStringValue:@""];
}


@end
