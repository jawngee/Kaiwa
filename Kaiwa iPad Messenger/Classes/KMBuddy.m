//
//  KMBuddy.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KMBuddy.h"

@implementation KMBuddy

@synthesize userName, status, image, friend;


-(id)initWithFriend:(KaiwaFriend *)afriend
{
	if (self=[super init])
	{
		friend=[afriend retain];
		
		userName=friend.user;
		status=@"Available";
		image=nil;
	}
	
	return self;
}

-(void)dealloc
{
	[friend release];
	[status release];
	[image release];
	
	[super dealloc];
}

@end
