//
//  KaiwaConversation.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KaiwaConversation.h"


@implementation KaiwaConversation

@synthesize request, response, friend;

-(id)initWithRequest:(KaiwaRequest *)req andResponse:(KaiwaResponse *)res forFriend:(KaiwaFriend *)theFriend
{
	if (self=[super init])
	{
		request=[req retain];
		response=[res retain];
		friend=[theFriend retain];
	}
	
	return self;
}

+(id)conversationWithRequest:(KaiwaRequest *)req andResponse:(KaiwaResponse *)res forFriend:(KaiwaFriend *)theFriend
{
	return [[[KaiwaConversation alloc] initWithRequest:req andResponse:res forFriend:theFriend] autorelease];
}

-(void)dealloc
{
	[request release];
	[response release];
	[friend release];
	
	[super dealloc];
}


@end
