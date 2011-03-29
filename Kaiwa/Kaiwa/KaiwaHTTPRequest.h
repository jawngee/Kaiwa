//
//  KaiwaHTTPRequest.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

/**
 Block def to call when asking a friend something.
 */
typedef void(^KaiwaHTTPRequestCompleteBlock)(BOOL success, id request);

@interface KaiwaHTTPRequest : ASIHTTPRequest {

@private KaiwaHTTPRequestCompleteBlock _completeBlock;
@private NSThread *callerThread;
	
	
}

-(void)startAsynchronous:(KaiwaHTTPRequestCompleteBlock)completeBlock;

@end

@interface KaiwaFormDataRequest : ASIFormDataRequest {
	
@private KaiwaHTTPRequestCompleteBlock _completeBlock;
@private NSThread *callerThread;
	
}

-(void)startAsynchronous:(KaiwaHTTPRequestCompleteBlock)completeBlock;

@end
