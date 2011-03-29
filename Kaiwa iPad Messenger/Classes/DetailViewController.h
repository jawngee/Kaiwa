//
//  DetailViewController.h
//  Kaiwa iPad Messenger
//
//  Created by Jon Gilkison on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMBuddy.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    KMBuddy *detailItem;
	
	IBOutlet UITextView *messageView;
	IBOutlet UITextField *messageField;
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *nameLabel;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;


-(IBAction)sendMessage:(id)sender;
-(void)addMessage:(NSString *)string;

@end
