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
#import <CoreServices/CoreServices.h>
#import <Collaboration/Collaboration.h>

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
	[dispatcher release];
	
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
	KMBuddy *buddy=[[KMBuddy alloc] initWithFriend:newFriend];
	[friendsArrayController addObject:buddy];
	
	[newFriend ask:@"/command/userImage" withData:nil forBlock:^(BOOL success, id res){
		buddy.image=[[[NSImage alloc] initWithData:res] autorelease];
	}];
	
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

-(void)userImageAction:(KaiwaConversation *)convo
{
	NSData *imgData = nil;
	
	NSString *currentUser=NSUserName();
	
	CSIdentityAuthorityRef defaultAuthority = CSGetLocalIdentityAuthority();
	CSIdentityClass identityClass = kCSIdentityClassUser;
	
	CSIdentityQueryRef query = CSIdentityQueryCreate(NULL, identityClass, defaultAuthority);
	
	CFErrorRef error = NULL;
	CSIdentityQueryExecute(query, 0, &error);
	
	CFArrayRef results = CSIdentityQueryCopyResults(query);
	
	int numResults = CFArrayGetCount(results);
	
	for (int i = 0; i < numResults; ++i) {
		CSIdentityRef identity = (CSIdentityRef)CFArrayGetValueAtIndex(results, i);
		
		CBIdentity * identityObject = [CBIdentity identityWithCSIdentity:identity];
		if ([[identityObject posixName] isEqualToString:currentUser])
		{
			imgData=[[identityObject image] TIFFRepresentation];
			break;
		}
	}
	
	CFRelease(results);
	CFRelease(query);

	if (imgData!=nil)
		[convo.response sendData:imgData];
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

-(IBAction)statusChanged:(id)sender
{
	[dispatcher broadcastToFriends:@"/command/status" data:[NSDictionary dictionaryWithObject:[[sender selectedItem] title] forKey:@"status"]];
}


@end
