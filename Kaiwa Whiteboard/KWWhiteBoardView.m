//
//  KWWhiteboardView.m
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KWWhiteBoardView.h"
#import "KWScribble.h"
#import "KWScribblePoint.h"

@implementation KWWhiteBoardView

@synthesize currentColor, currentLineWidth;

-(void)awakeFromNib
{
	[super awakeFromNib];

	currentColor=[NSColor redColor];
	currentLineWidth=5;

	scribbles=[[NSMutableArray arrayWithCapacity:0] retain];
	liveScribbles=[[NSMutableDictionary dictionaryWithCapacity:0] retain];
}

-(void)dealloc
{
	[scribbles release];
	[liveScribbles release];
	
	[super dealloc];
}


-(void)friendMouseDown:(KaiwaFriend *)friend x:(float)x y:(float)y lineWidth:(float)lineWidth lineColor:(NSColor *)lineColor
{
	NSPoint p=NSMakePoint(x, y);
	KWScribble *current=[liveScribbles objectForKey:friend.uid];
	
	if (!current)
	{
		current=[KWScribble scribbleWithFriend:friend color:lineColor lineWidth:lineWidth initialX:p.x initialY:p.y];
		[liveScribbles setObject:current forKey:friend.uid];
		[scribbles addObject:current];
	}
	else
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay:YES];
	}
}

-(void)friendMouseDragged:(KaiwaFriend *)friend x:(float)x y:(float)y
{
	NSPoint p=NSMakePoint(x, y);
	KWScribble *current=[liveScribbles objectForKey:friend.uid];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay:YES];
	}
}

-(void)friendMouseUp:(KaiwaFriend *)friend x:(float)x y:(float)y
{
	NSPoint p=NSMakePoint(x, y);
	KWScribble *current=[liveScribbles objectForKey:friend.uid];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay:YES];
		
		[liveScribbles removeObjectForKey:friend.uid];
	}
}


-(void)mouseDown:(NSEvent*)event
{
	NSPoint p=[self convertPoint:[event locationInWindow] fromView:nil];
	KWScribble *current=[liveScribbles objectForKey:@"SELF"];
	
	if (!current)
	{
		current=[KWScribble scribbleWithFriend:nil color:currentColor lineWidth:currentLineWidth initialX:p.x initialY:p.y];
		[liveScribbles setObject:current forKey:@"SELF"];
		[scribbles addObject:current];
	}
	else
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay:YES];
	}
	
	[delegate whiteBoardMouseDown:p lineWidth:currentLineWidth andColor:currentColor];
}

-(void)mouseDragged:(NSEvent*)event
{
	NSPoint p=[self convertPoint:[event locationInWindow] fromView:nil];
	KWScribble *current=[liveScribbles objectForKey:@"SELF"];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay:YES];
	}
	
	[delegate whiteBoardMouseDragged:p];
}

-(void)mouseUp:(NSEvent*)event
{
	NSPoint p=[self convertPoint:[event locationInWindow] fromView:nil];
	KWScribble *current=[liveScribbles objectForKey:@"SELF"];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay:YES];
		
		[liveScribbles removeObjectForKey:@"SELF"];
	}
	
	[delegate whiteBoardMouseUp:p];
}

-(BOOL)isFlipped
{
	return YES;
}

-(void)drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] set];
	NSRectFill(dirtyRect);
	
	for(KWScribble *scribble in scribbles)
	{
		NSBezierPath *path=[NSBezierPath bezierPath];
		
		KWScribblePoint *p=[scribble.points objectAtIndex:0];
		
		[path moveToPoint:NSMakePoint(p.x, p.y)];
		
		for(int i=1; i<[scribble.points count]; i++)
		{
			p=[scribble.points objectAtIndex:i];
			
			[path lineToPoint:NSMakePoint(p.x, p.y)];
		}
		
		[path setLineJoinStyle:NSRoundLineJoinStyle];
		[path setLineCapStyle:NSRoundLineCapStyle];
		
		[path setLineWidth:scribble.lineWidth];
		[scribble.color setStroke];
		[path stroke];
	}
	
}


-(void)clearTheirs:(KaiwaFriend *)friend
{
	for(int i=[scribbles count]-1; i--; i>=0)
	{
		KWScribble *s=[scribbles objectAtIndex:i];
		if ((s.friend!=nil) && ([s.friend.uid isEqualToString:friend.uid]))
			[scribbles removeObjectAtIndex:i];
	}
	
	[self setNeedsDisplay:YES];
}

-(void)clearMine
{
	for(int i=[scribbles count]-1; i--; i>=0)
	{
		KWScribble *s=[scribbles objectAtIndex:i];
		if (s.friend==nil)
			[scribbles removeObjectAtIndex:i];
	}
	
	[self setNeedsDisplay:YES];
}

-(void)clearAll
{
	[scribbles removeAllObjects];
	[self setNeedsDisplay:YES];
}

@end
