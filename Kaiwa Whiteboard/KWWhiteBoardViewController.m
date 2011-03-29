//
//  KSWhiteBoardViewController.m
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KWWhiteBoardViewController.h"
#import "KWBuddy.h"
#import <KaiwaFramework/RandomSequence.h>
#import <Collaboration/Collaboration.h>

@implementation KWWhiteBoardViewController

-(void)awakeFromNib
{
	[super awakeFromNib];
	
	friends=[[NSMutableDictionary dictionaryWithCapacity:0] retain];
	
	dispatcher=[[KaiwaDispatcher alloc] initWithType:@"_kaiwaWhiteBoard._tcp" port:8181];
	dispatcher.delegate=self;
	dispatcher.OSCEnabled=YES;
	dispatcher.OSCPort=[RandomSequence randomValueBetweenLowerValue:16384 andUpperValue:32767];
	
	[dispatcher registerRoute:@"/command/(.*)" forInstance:self];
	
	[dispatcher start];
	
	[dispatcher findFriends];
}

#pragma mark -
#pragma mark Kaiwa protocols

-(void)foundFriend:(KaiwaFriend *)newFriend
{
	KWBuddy *buddy=[[KWBuddy alloc] initWithFriend:newFriend];
	[friends setObject:buddy forKey:newFriend.uid];
	
	[newFriend ask:@"/command/userImage" withData:nil forBlock:^(BOOL success, id res){
		buddy.image=[[[NSImage alloc] initWithData:res] autorelease];
	}];
	
	NSLog(@"Found friend:%@",newFriend.url);
}

-(void)lostFriend:(KaiwaFriend *)oldFriend
{
	NSLog(@"Lost friend:%@",oldFriend.url);
	
	[friends removeObjectForKey:oldFriend.uid];
}

#pragma mark -
#pragma mark kaiwa actions

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

-(void)mouseDownAction:(KaiwaConversation *)convo
{
	float x=[[convo.request.query objectForKey:@"x"] floatValue];
	float y=[[convo.request.query objectForKey:@"y"] floatValue];
	float lineWidth=[[convo.request.query objectForKey:@"lineWidth"] floatValue];
	NSColor *lineColor=[NSColor colorFromHexString:[convo.request.query objectForKey:@"lineColor"]];

	[whiteBoard friendMouseDown:convo.friend x:x y:y lineWidth:lineWidth lineColor:lineColor];
}


-(void)mouseUpAction:(KaiwaConversation *)convo
{
	NSLog(@"MOUSE UP");
	float x=[[convo.request.query objectForKey:@"x"] floatValue];
	float y=[[convo.request.query objectForKey:@"y"] floatValue];
	
	[whiteBoard friendMouseUp:convo.friend x:x y:y];
}


-(void)mouseDraggedAction:(KaiwaShout *)shout
{
	float x=[[shout.arguments objectAtIndex:0] floatValue];
	float y=[[shout.arguments objectAtIndex:1] floatValue];
	
	[whiteBoard friendMouseDragged:shout.friend x:x y:y];
}

-(void)clearMineAction:(KaiwaConversation *)convo
{
	NSLog(@"CLEAR MINE");
	// they are asking to clear theirs when they call /command/clearMine
	[whiteBoard clearTheirs:convo.friend];
}

-(void)clearTheirsAction:(KaiwaConversation *)convo
{
	NSLog(@"CLEAR THEIRS");
	// they are asking to clear mine when they call /command/clearTheirs
	[whiteBoard clearMine];
}

-(void)clearAllAction:(KaiwaConversation *)convo
{
	NSLog(@"CLEAR ALL");
	[whiteBoard clearAll];
}


#pragma mark -
#pragma mark white board delegate

-(void)whiteBoardMouseDown:(NSPoint)point lineWidth:(float)lineWidth andColor:(NSColor *)color
{
	[dispatcher broadcastToFriends:@"/command/mouseDown" data:[NSDictionary dictionaryWithObjectsAndKeys:
																[NSNumber numberWithFloat:point.x],@"x",
															   [NSNumber numberWithFloat:point.y],@"y",
															   [NSNumber numberWithFloat:lineWidth],@"lineWidth",
															   [color hexColorString],@"lineColor",
																nil]];
}

-(void)whiteBoardMouseDragged:(NSPoint)point
{
	[dispatcher shoutToFriends:@"/command/mouseDragged" data:[NSArray arrayWithObjects:[NSNumber numberWithFloat:point.x],[NSNumber numberWithFloat:point.y],nil]];
}

-(void)whiteBoardMouseUp:(NSPoint)point
{
	NSLog(@"FRIEND MOUSE UP");
	[dispatcher broadcastToFriends:@"/command/mouseUp" data:[NSDictionary dictionaryWithObjectsAndKeys:
																   [NSNumber numberWithFloat:point.x],@"x",
																   [NSNumber numberWithFloat:point.y],@"y",
																   nil]];
}


#pragma mark -
#pragma mark UI actions

-(IBAction)setColor:(id)sender
{
	whiteBoard.currentColor=[colorWell color];
}

-(IBAction)setLineSize:(id)sender
{
	whiteBoard.currentLineWidth=[lineSizeSlider floatValue];
}


-(IBAction)clearTheirs:(id)sender
{
	[dispatcher broadcastToFriends:@"/command/clearTheirs" data:nil];
	
	for(KWBuddy *b in [friends allValues])
		[whiteBoard clearTheirs:b.friend];
}

-(IBAction)clearMine:(id)sender
{
	[dispatcher broadcastToFriends:@"/command/clearMine" data:nil];
	
	[whiteBoard clearMine];
}

-(IBAction)clearAll:(id)sender
{
	[dispatcher broadcastToFriends:@"/command/clearAll" data:nil];
	[whiteBoard clearAll];
}

@end
