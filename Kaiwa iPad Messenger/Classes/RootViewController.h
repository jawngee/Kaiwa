//
//  RootViewController.h
//  Kaiwa iPad Messenger
//
//  Created by Jon Gilkison on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kaiwa.h"

@class DetailViewController;

@interface RootViewController : UITableViewController<KaiwaDispatcherProtocol> {
	
    DetailViewController *detailViewController;
	
	NSMutableArray *friends;
	KaiwaDispatcher *dispatcher;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
