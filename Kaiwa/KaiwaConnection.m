//
//  KaiwaConnection.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaConnection.h"
#import "KaiwaHTTPServer.h"
#import "KaiwaDispatcher.h"
#import "NSDictionary+URLEncode.h"

@implementation KaiwaConnection

#pragma mark response handler

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
	return YES;
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)relativePath
{
	// Inform HTTP server that we expect a body to accompany a POST request
	NSLog(@"cl:%@",[headers objectForKey:@"Content-Length"]);
	if([method isEqualToString:@"POST"])
		return YES;
	
	return [super expectsRequestBodyFromMethod:method atPath:relativePath];
}

- (void)processDataChunk:(NSData *)postDataChunk
{
	BOOL result = CFHTTPMessageAppendBytes(request, [postDataChunk bytes], [postDataChunk length]);
	
	if(!result)
	{
		NSLog(@"Couldn't append bytes!");
	}
}


- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	NSDictionary *parsedPostData=nil;
	
	if([method isEqualToString:@"POST"])
	{
		NSString *postStr = nil;
		
		CFDataRef postData = CFHTTPMessageCopyBody(request);
		if(postData)
		{
			postStr = [[[NSString alloc] initWithData:(NSData *)postData encoding:NSUTF8StringEncoding] autorelease];
			CFRelease(postData);
		}
		
		NSLog(@"postStr: %@", postStr);
		parsedPostData=[NSDictionary parsedQuery:postStr];
	}
	
	KaiwaHTTPServer *kServer=(KaiwaHTTPServer *)server;
	return [kServer.dispatcher dispatch:path forMethod:method withConnection:self postData:parsedPostData];
}


@end