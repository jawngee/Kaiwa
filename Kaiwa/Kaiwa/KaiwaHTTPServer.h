//
//  KaiwaHTTPServer.h
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/25/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ThreadPoolServer.h"

@class KaiwaDispatcher;

@interface KaiwaHTTPServer : ThreadPoolServer 
{
	KaiwaDispatcher *dispatcher;
}

@property (readonly) KaiwaDispatcher *dispatcher;

-(id)initWithDispatcher:(KaiwaDispatcher *)theDispatcher;

@end
