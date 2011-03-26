//
//  KaiwaConversation.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 Interfacelab LLC. All rights reserved.
//

#if IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
#import "KaiwaRequest.h"
#import "KaiwaResponse.h"
#import "KaiwaFriend.h"

/**
 Represents a conversation between two Kaiwa friends.  This is sent in as the first argument
 to any action called by the dispatcher.
 */
@interface KaiwaConversation : NSObject {
	KaiwaRequest *request;			/**< The request */
	KaiwaResponse *response;		/**< The response */
	KaiwaFriend *friend;			/**< The friend the request is associated with, may be nil */
}

@property (readonly) KaiwaRequest *request;
@property (readonly) KaiwaResponse *response;
@property (readonly) KaiwaFriend *friend;

/**
 Creates a new conversation for an incoming request and outgoing response.
 @param req The incoming request.
 @param res The outgoing response.
 @param theFriend The friend this is associated with.
 */
-(id)initWithRequest:(KaiwaRequest *)req andResponse:(KaiwaResponse *)res forFriend:(KaiwaFriend *)theFriend;

/**
 Creates a new conversation for an incoming request and outgoing response.
 @param req The incoming request.
 @param res The outgoing response.
 @param theFriend The friend this is associated with.
 */
+(id)conversationWithRequest:(KaiwaRequest *)req andResponse:(KaiwaResponse *)res forFriend:(KaiwaFriend *)theFriend;

@end
