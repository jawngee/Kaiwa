//
//  KWScribble.h
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KaiwaFramework/Kaiwa.h>

@interface KWScribble : NSObject {
	KaiwaFriend *friend;
	float lineWidth;
	NSColor *color;
	NSMutableArray *points;
}

@property (readonly) KaiwaFriend *friend;
@property (readonly) float lineWidth;
@property (readonly) NSColor *color;
@property (readonly) NSMutableArray *points;

-(id)initWithFriend:(KaiwaFriend *)theFriend color:(NSColor*)theColor lineWidth:(float)theLineWidth initialX:(float)x initialY:(float)y;
+(id)scribbleWithFriend:(KaiwaFriend *)theFriend color:(NSColor*)theColor lineWidth:(float)theLineWidth initialX:(float)x initialY:(float)y;

-(void)addPointWithX:(float)x andY:(float)y;

@end
