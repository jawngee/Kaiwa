//
//  KMBuddy.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KWBuddy.h"

@implementation KWBuddy

@synthesize userName, image, friend;


-(id)initWithFriend:(KaiwaFriend *)afriend
{
	if (self=[super init])
	{
		friend=[afriend retain];
		
		userName=friend.user;
		//image=[[NSImage imageNamed:@"NSEveryone"] retain];
	}
	
	return self;
}

-(void)dealloc
{
	[friend release];
	[image release];
	
	[super dealloc];
}

@end
