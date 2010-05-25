//
//  KaiwaController.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaController.h"


@implementation KaiwaController

#pragma mark initialization

-(id)init
{
	if ((self=[super init]))
	{
		request=nil;
		response=nil;
	}
	
	return self;
}

-(void)dealloc
{
	if (request!=nil)
		[request release];
	
	if (response!=nil)
		[response release];

	[super dealloc];
}

#pragma mark controller protocol implementation

-(void)setRequest:(KaiwaRequest *)theRequest
{
	request=[theRequest retain];
}

-(void)setResponse:(KaiwaResponse *)theResponse
{
	response=[theResponse retain];
}

@end
