//
//  KMBuddy.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KMBuddy.h"
#import "KMMessageWindowController.h"

@implementation KMBuddy

@synthesize userName, status, imageURL, friend, messageWindowController;


-(id)initWithFriend:(KaiwaFriend *)afriend
{
	if (self=[super init])
	{
		friend=[afriend retain];
		
		userName=friend.user;
		status=@"Available";
		imageURL=nil;
		
		messageWindowController=[[KMMessageWindowController alloc] initWithBuddy:self];
	}
	
	return self;
}

-(void)dealloc
{
	[friend release];
	[status release];
	[imageURL release];
	
	[messageWindowController release];
	
	[super dealloc];
}

@end
