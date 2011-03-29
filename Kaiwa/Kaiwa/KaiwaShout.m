//
//  KaiwaShout.m
//  KaiwaFramework
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KaiwaShout.h"


@implementation KaiwaShout

@synthesize uri,friend,arguments;

-(id)initWithURI:(NSString *)theURI withArguments:(NSArray *)theArgs forFriend:(KaiwaFriend *)theFriend
{
	if (self=[super init])
	{
		uri=[theURI retain];
		arguments=[theArgs retain];
		friend=[theFriend retain];
	}
	
	return self;
}

+(id)shoutWithURI:(NSString *)theURI withArguments:(NSArray *)theArgs forFriend:(KaiwaFriend *)theFriend
{
	return [[[KaiwaShout alloc] initWithURI:theURI withArguments:theArgs forFriend:theFriend] autorelease];
}

-(void)dealloc
{
	[uri release];
	[arguments release];
	[friend release];
	
	[super dealloc];
}

@end
