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

#pragma mark initialization

-(id)initWithConnection:(KaiwaConnection *)theConnection
{
	if ((self=[super init]))
	{
		connection=theConnection;
		cookies=[[[NSMutableArray alloc] init] retain];
		headers=[[[NSMutableArray alloc] init] retain];
		output=[[[NSMutableData alloc] init] retain];
		contentType=[@"text/xml" retain];
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
	if (filePath!=nil)
		return [[[HTTPAsyncFileResponse alloc] initWithFilePath:filePath forConnection:connection runLoopModes:[connection.asyncSocket runLoopModes]] autorelease];
	else
		return [[[HTTPDataResponse alloc] initWithData:output] autorelease];
}


@end
