//
//  KMBuddyView.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KMBuddyView : NSView {
	IBOutlet id delegate;
	IBOutlet id buddy;
}

@end
