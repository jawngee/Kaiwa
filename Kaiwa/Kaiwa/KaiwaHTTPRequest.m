//
//  KaiwaHTTPRequest.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KaiwaHTTPRequest.h"


@implementation KaiwaHTTPRequest

-(void)completeSuccess
{
	_completeBlock(YES,self);
}

-(void)completeFail
{
	_completeBlock(NO,self);
}

-(void)requestFinished
{
	[super requestFinished];
	[self performSelector:@selector(completeSuccess) onThread:callerThread withObject:nil waitUntilDone:NO];
}	


- (void)failWithError:(NSError *)theError
{
	[super failWithError:theError];
	[self performSelector:@selector(completeFail) onThread:callerThread withObject:nil waitUntilDone:NO];
}

-(void)startAsynchronous:(KaiwaHTTPRequestCompleteBlock)completeBlock
{
	callerThread=[NSThread currentThread];
	_completeBlock=[[completeBlock copy] retain];
	[self startAsynchronous];
}

@end

@implementation KaiwaFormDataRequest

-(void)completeSuccess
{
	_completeBlock(YES,self);
}

-(void)completeFail
{
	_completeBlock(NO,self);
}

-(void)requestFinished
{
	[super requestFinished];
	[self performSelector:@selector(completeSuccess) onThread:callerThread withObject:nil waitUntilDone:NO];
}	


- (void)failWithError:(NSError *)theError
{
	[super failWithError:theError];
	[self performSelector:@selector(completeFail) onThread:callerThread withObject:nil waitUntilDone:NO];
}

-(void)startAsynchronous:(KaiwaHTTPRequestCompleteBlock)completeBlock
{
	callerThread=[NSThread currentThread];
	_completeBlock=[[completeBlock copy] retain];
	[self startAsynchronous];
}

@end