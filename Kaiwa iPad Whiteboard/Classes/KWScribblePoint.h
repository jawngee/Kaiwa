//
//  KWScribblePoint.h
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



@interface KWScribblePoint : NSObject {
	float x;
	float y;
}

@property (assign) float x;
@property (assign) float y;


-(id)initWithX:(float)theX andY:(float)theY;
+(id)pointWithX:(float)theX andY:(float)theY;

@end
