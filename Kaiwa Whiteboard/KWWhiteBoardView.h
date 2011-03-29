//
//  KWWhiteboardView.h
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KWBuddy.h"

@protocol KWWhiteBoardViewDelegate

-(void)whiteBoardMouseDown:(NSPoint)point lineWidth:(float)lineWidth andColor:(NSColor *)color;
-(void)whiteBoardMouseDragged:(NSPoint)point;
-(void)whiteBoardMouseUp:(NSPoint)point;

@end


@interface KWWhiteBoardView : NSView {
	IBOutlet id delegate;
	
	NSColor *currentColor;
	float currentLineWidth;
	
	NSMutableArray *scribbles;
	NSMutableDictionary *liveScribbles;
}

@property (retain, nonatomic) NSColor *currentColor;
@property (assign, nonatomic) float currentLineWidth;

-(void)friendMouseDown:(KaiwaFriend *)friend x:(float)x y:(float)y lineWidth:(float)lineWidth lineColor:(NSColor *)lineColor;
-(void)friendMouseDragged:(KaiwaFriend *)friend x:(float)x y:(float)y;
-(void)friendMouseUp:(KaiwaFriend *)friend x:(float)x y:(float)y;

-(void)clearTheirs:(KaiwaFriend *)friend;
-(void)clearMine;
-(void)clearAll;

@end
