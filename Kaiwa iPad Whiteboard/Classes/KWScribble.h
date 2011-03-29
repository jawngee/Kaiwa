//
//  KWScribble.h
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Kaiwa.h"

@interface KWScribble : NSObject {
	KaiwaFriend *friend;
	float lineWidth;
	UIColor *color;
	NSMutableArray *points;
}

@property (readonly) KaiwaFriend *friend;
@property (readonly) float lineWidth;
@property (readonly) UIColor *color;
@property (readonly) NSMutableArray *points;

-(id)initWithFriend:(KaiwaFriend *)theFriend color:(UIColor*)theColor lineWidth:(float)theLineWidth initialX:(float)x initialY:(float)y;
+(id)scribbleWithFriend:(KaiwaFriend *)theFriend color:(UIColor*)theColor lineWidth:(float)theLineWidth initialX:(float)x initialY:(float)y;

-(void)addPointWithX:(float)x andY:(float)y;

@end
