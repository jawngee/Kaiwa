//
//  KMBuddyListController.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KMBuddyListController.h"
#import "KMBuddy.h"
#import "KMMessageWindowController.h"

@implementation KMBuddyListController


-(id)init
{
	if (self=[super init])
	{
	}
	
	
	return self;
}

-(void)dealloc
{
	
	[super dealloc];
}

-(void)awakeFromNib
{
	dispatcher=[[KaiwaDispatcher alloc] initWithType:@"_kaiwaMessenger._tcp" port:8181];
	dispatcher.delegate=self;

	[dispatcher registerRoute:@"/command/(.*)" forInstance:self];
	
	[dispatcher start];
	
	[dispatcher findFriends];
}

#pragma mark -
#pragma mark Kaiwa protocols

-(void)foundFriend:(KaiwaFriend *)newFriend
{
	[friendsArrayController performSelectorOnMainThread:@selector(addObject:) withObject:[[KMBuddy alloc] initWithFriend:newFriend] waitUntilDone:YES];
	
	NSLog(@"Found friend:%@",newFriend.url);
}

-(void)lostFriend:(KaiwaFriend *)oldFriend
{
	NSLog(@"Lost friend:%@",oldFriend.url);
	
	for(KMBuddy *buddy in [friendsArrayController arrangedObjects])
		if ([buddy.friend.url isEqualToString:oldFriend.url])
		{
			[friendsArrayController removeObject:buddy];
			break;
		}

}


#pragma mark -
#pragma mark Commands

-(void)messageAction:(KaiwaConversation *)convo
{
	KMBuddy *buddy=nil;
	
	for(KMBuddy *bud in [friendsArrayController arrangedObjects])
		if ([bud.friend.url isEqualToString:convo.friend.url])
		{
			buddy=bud;
			break;
		}
	
	if (buddy!=nil)
	{
		NSString *message=[convo.request.query objectForKey:@"message"];
		[buddy.messageWindowController showWindow:nil];
		[buddy.messageWindowController receiveMessage:message];
	}
}

-(void)statusAction:(KaiwaConversation *)convo
{
	KMBuddy *buddy=nil;
	
	for(KMBuddy *bud in [friendsArrayController arrangedObjects])
		if ([bud.friend.url isEqualToString:convo.friend.url])
		{
			buddy=bud;
			break;
		}
	
	if (buddy!=nil)
		buddy.status=[convo.request.query objectForKey:@"status"];
}


#pragma mark -
#pragma mark mouse actions

-(IBAction)doubleClick:(id)sender
{
	KMBuddy *buddy=nil;
	
	for(KMBuddy *bud in [friendsArrayController arrangedObjects])
		if ([bud.friend.url isEqualToString:[[[sender representedObject] valueForKey:@"friend"] valueForKey:@"url"]])
		{
			buddy=bud;
			break;
		}
	
	if (buddy!=nil)
	{
		[buddy.messageWindowController showWindow:nil];
	}
}


@end
