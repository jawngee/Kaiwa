//
//  KWScribblePoint.m
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KWScribblePoint.h"


@implementation KWScribblePoint

@synthesize x,y;

-(id)initWithX:(float)theX andY:(float)theY
{
	if (self=[super init])
	{
		x=theX;
		y=theY;
	}
	
	return self;
}

+(id)pointWithX:(float)theX andY:(float)theY
{
	return [[[KWScribblePoint alloc] initWithX:theX andY:theY] autorelease];
}


@end
