//
//  KMBuddy.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KaiwaFramework/Kaiwa.h>

@class KMMessageWindowController;

@interface KMBuddy : NSObject {
	KaiwaFriend *friend;
	NSString *userName;
	NSString *status;
	NSImage *image;
	
	KMMessageWindowController *messageWindowController;
}


@property (retain, nonatomic) KaiwaFriend *friend;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *status;
@property (retain, nonatomic) NSImage *image;
@property (readonly) KMMessageWindowController *messageWindowController;


-(id)initWithFriend:(KaiwaFriend *)afriend;

@end
