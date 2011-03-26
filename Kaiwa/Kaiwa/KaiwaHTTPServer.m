//
//  KaiwaHTTPServer.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/25/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaHTTPServer.h"
#import "KaiwaDispatcher.h"

@implementation KaiwaHTTPServer

@synthesize dispatcher;

-(id)initWithDispatcher:(KaiwaDispatcher *)theDispatcher
{
	if ((self=[super init]))
	{
		dispatcher=theDispatcher;
	}
	
	return self;
}

@end
