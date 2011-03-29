//
//  Kaiwa_iPad_WhiteboardViewController.h
//  Kaiwa iPad Whiteboard
//
//  Created by Jon Gilkison on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWBuddy.h"
#import "KWWhiteBoardView.h"
#import "Kaiwa.h"


@interface Kaiwa_iPad_WhiteboardViewController : UIViewController {
	IBOutlet KWWhiteBoardView *whiteBoard;
	KaiwaDispatcher *dispatcher;
	
	NSMutableDictionary *friends;
}

@end

