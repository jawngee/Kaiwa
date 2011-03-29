//
//  KWWhiteBoardView.m
//  Kaiwa iPad Whiteboard
//
//  Created by Jon Gilkison on 3/29/11.
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
	
	currentColor=[UIColor redColor];
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

-(void)friendMouseDown:(KaiwaFriend *)friend x:(float)x y:(float)y lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor
{	
	CGPoint p=CGPointMake(x, y);
	KWScribble *current=[KWScribble scribbleWithFriend:friend color:lineColor lineWidth:lineWidth initialX:p.x initialY:p.y];
	[liveScribbles setObject:current forKey:friend.uid];
	[scribbles addObject:current];
	[self setNeedsDisplay];
}

-(void)friendMouseDragged:(KaiwaFriend *)friend x:(float)x y:(float)y
{
	CGPoint p=CGPointMake(x, y);
	KWScribble *current=[liveScribbles objectForKey:friend.uid];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay];
	}
}

-(void)friendMouseUp:(KaiwaFriend *)friend x:(float)x y:(float)y
{
	CGPoint p=CGPointMake(x, y);
	KWScribble *current=[liveScribbles objectForKey:friend.uid];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay];
		
		[liveScribbles removeObjectForKey:friend.uid];
	}
}


-(void)clearTheirs:(KaiwaFriend *)friend
{
	for(int i=[scribbles count]; i--; i>=0)
	{
		KWScribble *s=[scribbles objectAtIndex:i];
		if ((s.friend!=nil) && ([s.friend.uid isEqualToString:friend.uid]))
			[scribbles removeObjectAtIndex:i];
	}
	
	[self setNeedsDisplay];
}

-(void)clearMine
{
	for(int i=[scribbles count]; i--; i>=0)
	{
		KWScribble *s=[scribbles objectAtIndex:i];
		if (s.friend==nil)
			[scribbles removeObjectAtIndex:i];
	}
	
	[self setNeedsDisplay];
}

-(void)clearAll
{
	[scribbles removeAllObjects];
	[self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch=[[[event allTouches] allObjects] objectAtIndex:0];
	CGPoint p=[touch locationInView:self];
	
	KWScribble *current=[KWScribble scribbleWithFriend:nil color:currentColor lineWidth:currentLineWidth initialX:p.x initialY:p.y];
	[liveScribbles setObject:current forKey:@"SELF"];
	[scribbles addObject:current];
	[self setNeedsDisplay];
	
	[delegate whiteBoardMouseDown:p lineWidth:currentLineWidth andColor:currentColor];
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch=[[[event allTouches] allObjects] objectAtIndex:0];
	CGPoint p=[touch locationInView:self];
	
	KWScribble *current=[liveScribbles objectForKey:@"SELF"];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay];
	}
	
	[delegate whiteBoardMouseDragged:p];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch=[[[event allTouches] allObjects] objectAtIndex:0];
	CGPoint p=[touch locationInView:self];
	
	KWScribble *current=[liveScribbles objectForKey:@"SELF"];
	
	if (current)
	{
		[current addPointWithX:p.x andY:p.y];
		[self setNeedsDisplay];
		
		[liveScribbles removeObjectForKey:@"SELF"];
	}
	
	[delegate whiteBoardMouseUp:p];
}

-(BOOL)isFlipped
{
	return YES;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef myContext = UIGraphicsGetCurrentContext();

	[[UIColor whiteColor] set];	
	
	CGContextFillRect(myContext, rect);
	
	for(KWScribble *scribble in scribbles)
	{

		KWScribblePoint *p=[scribble.points objectAtIndex:0];
		
		CGContextMoveToPoint(myContext, p.x, p.y);
		
		for(int i=1; i<[scribble.points count]; i++)
		{
			p=[scribble.points objectAtIndex:i];

			CGContextAddLineToPoint(myContext, p.x, p.y);
		}
		
		CGContextSetLineJoin(myContext, kCGLineJoinRound);
		CGContextSetLineCap(myContext, kCGLineCapRound);
		CGContextSetLineWidth(myContext, scribble.lineWidth);
	
		[scribble.color setStroke];
		
		CGContextStrokePath(myContext);
	}
	
}


@end
