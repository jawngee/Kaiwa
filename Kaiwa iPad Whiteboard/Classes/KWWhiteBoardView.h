//
//  KWWhiteBoardView.h
//  Kaiwa iPad Whiteboard
//
//  Created by Jon Gilkison on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWBuddy.h"

@protocol KWWhiteBoardViewDelegate

-(void)whiteBoardMouseDown:(CGPoint)point lineWidth:(float)lineWidth andColor:(UIColor *)color;
-(void)whiteBoardMouseDragged:(CGPoint)point;
-(void)whiteBoardMouseUp:(CGPoint)point;

@end

@interface KWWhiteBoardView : UIView {
	IBOutlet id delegate;
	
	UIColor *currentColor;
	float currentLineWidth;
	
	NSMutableArray *scribbles;
	NSMutableDictionary *liveScribbles;
}

@property (retain, nonatomic) UIColor *currentColor;
@property (assign, nonatomic) float currentLineWidth;

-(void)friendMouseDown:(KaiwaFriend *)friend x:(float)x y:(float)y lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor;
-(void)friendMouseDragged:(KaiwaFriend *)friend x:(float)x y:(float)y;
-(void)friendMouseUp:(KaiwaFriend *)friend x:(float)x y:(float)y;

-(void)clearTheirs:(KaiwaFriend *)friend;
-(void)clearMine;
-(void)clearAll;

@end
