//
//  KSWhiteBoardViewController.h
//  Kaiwa Whiteboard
//
//  Created by Jon Gilkison on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KWWhiteBoardView.h"
#import <KaiwaFramework/Kaiwa.h>

@interface KWWhiteBoardViewController : NSObject<KaiwaDispatcherProtocol,KWWhiteBoardViewDelegate> {
	IBOutlet KWWhiteBoardView *whiteBoard;
	IBOutlet NSColorWell *colorWell;
	IBOutlet NSSlider *lineSizeSlider;
	
	KaiwaDispatcher *dispatcher;
	
	NSMutableDictionary *friends;
}

-(IBAction)setColor:(id)sender;
-(IBAction)setLineSize:(id)sender;

-(IBAction)clearTheirs:(id)sender;
-(IBAction)clearMine:(id)sender;
-(IBAction)clearAll:(id)sender;

@end
