//
//  KaiwaConversation.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KaiwaRequest.h"
#import "KaiwaResponse.h"
#import "KaiwaFriend.h"

@interface KaiwaConversation : NSObject {
	KaiwaRequest *request;
	KaiwaResponse *response;
	KaiwaFriend *friend;
}

@property (readonly) KaiwaRequest *request;
@property (readonly) KaiwaResponse *response;
@property (readonly) KaiwaFriend *friend;

-(id)initWithRequest:(KaiwaRequest *)req andResponse:(KaiwaResponse *)res forFriend:(KaiwaFriend *)theFriend;
+(id)conversationWithRequest:(KaiwaRequest *)req andResponse:(KaiwaResponse *)res forFriend:(KaiwaFriend *)theFriend;

@end
