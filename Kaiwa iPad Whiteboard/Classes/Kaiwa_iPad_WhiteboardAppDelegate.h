//
//  Kaiwa_iPad_WhiteboardAppDelegate.h
//  Kaiwa iPad Whiteboard
//
//  Created by Jon Gilkison on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Kaiwa_iPad_WhiteboardViewController;

@interface Kaiwa_iPad_WhiteboardAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Kaiwa_iPad_WhiteboardViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Kaiwa_iPad_WhiteboardViewController *viewController;

@end

