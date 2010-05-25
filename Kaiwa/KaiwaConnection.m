//
//  KaiwaConnection.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaConnection.h"
#import "KaiwaDispatcher.h"

@implementation KaiwaConnection

#pragma mark initialization

- (id)initWithAsyncSocket:(AsyncSocket *)newSocket forServer:(HTTPServer *)myServer
{
	if ((self=[super initWithAsyncSocket:newSocket forServer:myServer]))
	{
	}
	
	return self;
}

#pragma mark response handler

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	return [KaiwaDispatcher dispatch:path forMethod:method withConnection:self];
}


@end
