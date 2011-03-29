//
//  KaiwaShout.h
//  KaiwaFramework
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
#import "KaiwaFriend.h"

/**
 Represents a shout from one friend to another, typically over OSC.  This is sent in as the first argument
 to any action called by the dispatcher.
 */
@interface KaiwaShout : NSObject {
	NSString *uri;
	KaiwaFriend *friend;
	NSArray *arguments;
}

@property (readonly) NSString *uri;
@property (readonly) KaiwaFriend *friend;
@property (readonly) NSArray *arguments;

/**
 Creates a new shout for an incoming request.
 @param theURI The uri of the incoming request.
 @param theArgs The arguments for the incoming request.
 @param theFriend The friend this is associated with.
 */
-(id)initWithURI:(NSString *)theURI withArguments:(NSArray *)theArgs forFriend:(KaiwaFriend *)theFriend;

/**
 Creates a new shout for an incoming request.
 @param theURI The uri of the incoming request.
 @param theArgs The arguments for the incoming request.
 @param theFriend The friend this is associated with.
 */
+(id)shoutWithURI:(NSString *)theURI withArguments:(NSArray *)theArgs forFriend:(KaiwaFriend *)theFriend;


@end
