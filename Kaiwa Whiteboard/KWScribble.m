//
//  KWScribble.m
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KWScribble.h"
#import "KWScribblePoint.h"

@implementation KWScribble

@synthesize friend, color, points, lineWidth;

-(id)init
{
	if (self=[super init])
	{
		friend=nil;
		color=nil;
		points=[[NSMutableArray arrayWithCapacity:0] retain];
	}
	
	return self;
}


-(id)initWithFriend:(KaiwaFriend *)theFriend color:(NSColor*)theColor lineWidth:(float)theLineWidth initialX:(float)x initialY:(float)y
{
	if (self=[self init])
	{
		friend=[theFriend retain];
		color=[theColor retain];
		lineWidth=theLineWidth;
		
		[points addObject:[KWScribblePoint pointWithX:x andY:y]];
	}
	
	return self;
}


+(id)scribbleWithFriend:(KaiwaFriend *)theFriend color:(NSColor*)theColor lineWidth:(float)theLineWidth initialX:(float)x initialY:(float)y
{
	return [[[KWScribble alloc] initWithFriend:theFriend color:theColor lineWidth:theLineWidth initialX:x initialY:y] autorelease];
}

-(void)dealloc
{
	[friend release];
	[color release];
	[points release];
	
	[super dealloc];
}


-(void)addPointWithX:(float)x andY:(float)y
{
	[points addObject:[KWScribblePoint pointWithX:x andY:y]];
}

@end
