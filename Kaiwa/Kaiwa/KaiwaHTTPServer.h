//
//  KaiwaHTTPServer.h
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/25/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "ThreadPoolServer.h"

@class KaiwaDispatcher;

@interface KaiwaHTTPServer : ThreadPoolServer 
{
	KaiwaDispatcher *dispatcher;
}

@property (readonly) KaiwaDispatcher *dispatcher;

-(id)initWithDispatcher:(KaiwaDispatcher *)theDispatcher;

@end
