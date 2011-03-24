//
//  KMBuddyView.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KMBuddyView.h"


@implementation KMBuddyView

- (NSView *)hitTest:(NSPoint)aPoint
{
	if(NSPointInRect(aPoint,[self convertRect:[self bounds] toView:[self superview]])) {
		return self;
	} else {
		return nil;
	}
}

-(void)mouseDown:(NSEvent *)theEvent {
	[super mouseDown:theEvent];
	
	// check for click count above one, which we assume means it's a double click
	if([theEvent clickCount] > 1) {
		NSLog(@"WHAT");
		if(delegate && [delegate respondsToSelector:@selector(doubleClick:)]) {
			[delegate performSelector:@selector(doubleClick:) withObject:self];
		}
	}
}

@end
