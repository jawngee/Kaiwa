//
//  KaiwaFilePath.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaFilePath.h"


@implementation KaiwaFilePath

#pragma mark initialization

-(id)initWithURIBase:(NSString *)uriBase forPath:(NSString*)filePath isFile:(BOOL)isFile
{
	if (isFile==NO)
	{
		uriBase=[uriBase stringByAppendingString:@"/(\\S*)"];
		filePath=[filePath stringByAppendingString:@"/$1"];
	}
	
	if ((self=[super initWithRewrite:uriBase to:filePath]))
	{
	}
	
	return self;
}

#pragma mark check for filePath existance

-(NSString *)exists:(NSString*)uri;
{
	NSLog(@"%@",uri);
	NSLog(@"%@",rewriteSub);
	NSLog(@"%@",rewriteString);
	NSString *filePath=[self rewrite:uri];
	BOOL isDir=NO;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir])
	{
		if (isDir==NO)
			return filePath;
	}
	
	return nil;
}

@end
