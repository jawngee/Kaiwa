//
//  KaiwaResponse.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaResponse.h"
#import "KaiwaConnection.h"
#import "HTTPAsyncFileResponse.h"

@implementation KaiwaResponse

@synthesize headers,cookies;

#pragma mark initialization

-(id)initWithConnection:(KaiwaConnection *)theConnection
{
	if ((self=[super init]))
	{
		connection=theConnection;
		cookies=[[[NSMutableArray alloc] init] retain];
		headers=[[[NSMutableDictionary alloc] init] retain];
		output=[[[NSMutableData alloc] init] retain];
		contentType=[@"text/plain" retain];
		canWrite=YES;
		filePath=nil;
	}
	
	return self;
}

-(void)dealloc
{
	[cookies release];
	[headers release];
	[output release];
	[contentType release];
	
	if (filePath!=nil)
		[filePath release];

	[super dealloc];
}


-(void)addCookie:(HTTPCookie *)cookie
{
	cookie.domain=[connection.uri host];
	
	[cookies addObject:cookie];
}

#pragma mark write/respond

-(void)setContentType:(NSString *)newContentType
{
	contentType=[newContentType retain];
}


-(void)write:(NSString*)text
{
	if (canWrite==NO)
		return;

	[output appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)writeLine:(NSString*)text
{
	if (canWrite==NO)
		return;

	[self write:[text stringByAppendingString:@"\n"]];
}

-(void)sendFile:(NSString*)theFilePath
{
	filePath=theFilePath;
	canWrite=NO;
}

-(NSObject<HTTPResponse> *)httpResponse
{
	NSObject<HTTPResponse> *result;
	
	if (filePath!=nil)
		result=[[[HTTPAsyncFileResponse alloc] initWithFilePath:filePath forConnection:connection runLoopModes:[connection.asyncSocket runLoopModes]] autorelease];
	else
		result=[[[HTTPDataResponse alloc] initWithData:output] autorelease];
	
	[headers setObject:contentType forKey:@"Content-Type"];
	
	NSString *cookieHeader=@"";
	for(int i=0; i<[cookies count]; i++)
	{
		cookieHeader=[cookieHeader stringByAppendingString:[[cookies objectAtIndex:0] collapse]];
		if (i<[cookies count]-1)
			cookieHeader=[cookieHeader stringByAppendingString:@", "];
	}
	
	if ([cookieHeader isEqualToString:@""]==NO)
		[headers setObject:cookieHeader forKey:@"Set-Cookie"];
	
	[result setHeaders:headers];
	
	return result;
}


@end
