//
//  KaiwaRewrite.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaRewrite.h"


@implementation KaiwaRewrite

#pragma mark initialization

-(id)initWithRewrite:(NSString *)rewrite to:(NSString*)rewriteTo
{
	if ((self=[super init]))
	{
		rewriteString=[rewrite retain];
		rewriteRegex=[[AGRegex regexWithPattern:rewrite options:AGRegexCaseInsensitive] retain];
		rewriteSub=[rewriteTo retain];
	}
	
	return self;
}

-(void)dealloc
{
	[rewriteRegex release];
	[rewriteSub release];
	
	[super dealloc];
}

#pragma mark class methods

-(NSString *)rewrite:(NSString *)input
{
	return [rewriteRegex replaceWithString:rewriteSub inString:input];
}


@end
