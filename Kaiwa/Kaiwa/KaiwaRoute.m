//
//  KaiwaRoute.m
//  Kaiwa
//
//  Created by Jon Gilkison on 5/19/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import "KaiwaRoute.h"
#import "KaiwaConversation.h"
#import "KaiwaShout.h"

@implementation KaiwaRoute

#pragma mark initialization

-(id)initWithRoute:(NSString *)theRoute forClass:(Class)theClass persist:(BOOL)isPersistant
{
	if ((self==[super init]))
	{
		route=[theRoute retain];
		routeRegex=[[AGRegex regexWithPattern:route options:AGRegexCaseInsensitive] retain];
		handlerClass=theClass;
		handlerInstance=nil;
		persistsInstance=isPersistant;
	}
	
	return self;
}

-(id)initWithRoute:(NSString *)theRoute forInstance:(id)theInstance
{
	if ((self==[super init]))
	{
		route=[theRoute retain];
		routeRegex=[[AGRegex regexWithPattern:route options:AGRegexCaseInsensitive] retain];
		handlerInstance=[theInstance retain];
		selector=nil;
		persistsInstance=YES;
	}
	
	return self;
}

-(id)initWithRoute:(NSString *)theRoute forInstance:(id)theInstance andSelector:(SEL)theSelector
{
	if ((self==[super init]))
	{
		route=[theRoute retain];
		routeRegex=[[AGRegex regexWithPattern:route options:AGRegexCaseInsensitive] retain];
		handlerInstance=[theInstance retain];
		persistsInstance=YES;
		selector=theSelector;
	}
	
	return self;
	
}

-(id)initWithRoute:(NSString *)theRoute forClass:(Class)theClass persistInstance:(BOOL)isPersistant
{
	if ((self==[super init]))
	{
		route=[theRoute retain];
		routeRegex=[[AGRegex regexWithPattern:route options:AGRegexCaseInsensitive] retain];
		handlerClass=theClass;
		selector=nil;
		handlerInstance=nil;
		persistsInstance=isPersistant;
	}
	
	return self;
	
}

-(id)initWithRoute:(NSString *)theRoute forClass:(Class)theClass andSelector:(SEL)theSelector persistInstance:(BOOL)isPersistant
{
	if ((self==[super init]))
	{
		route=[theRoute retain];
		routeRegex=[[AGRegex regexWithPattern:route options:AGRegexCaseInsensitive] retain];
		handlerClass=theClass;
		selector=theSelector;
		handlerInstance=nil;
		persistsInstance=isPersistant;
	}
	
	return self;
}


-(void)dealloc
{
	if (handlerInstance!=nil)
	{
		[handlerInstance release];
		handlerInstance=nil;
	}
	
	[route release];
	[routeRegex release];
	
	[super dealloc];
}

#pragma mark invoke

-(BOOL)invoke:(KaiwaRequest *)req forResponse:(KaiwaResponse *)response andFriend:(KaiwaFriend *)requestFriend
{
	NSString *path=[req.url path];
	NSArray *matches=[routeRegex findAllInString:path];
	if ([matches count]==0)
		return NO;

	if (handlerInstance==nil)
	{
		if (handlerClass==nil)
			return NO;
		
		handlerInstance=[[[handlerClass alloc] init] retain];
	}
	
	BOOL result=NO;
	
//	SEL setReq=@selector(setRequest:);
//	SEL setRes=@selector(setResponse:);
//	
//	if ([handlerInstance respondsToSelector:setReq])
//		[handlerInstance performSelector:setReq withObject:req];
//	if ([handlerInstance respondsToSelector:setRes])
//		[handlerInstance performSelector:setRes withObject:response];
	
	
	// invoke
	SEL dasSelector=selector;
	if (dasSelector==nil)
	{
		NSString *method=nil;
		
		NSMutableArray *segments = [NSMutableArray array];
		NSScanner *scanner = [NSScanner scannerWithString:path];
		[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
		while (![scanner isAtEnd]) {
			NSString *seg=@"";
			[scanner scanUpToString:@"/" intoString:&seg];
			[segments addObject:seg];
		}

		if ([segments count]<2)
			method=@"defaultAction:";
		else
			method=[[segments objectAtIndex:1] stringByAppendingString:@"Action:"];
					
		dasSelector=NSSelectorFromString(method);
	}
		
	if ([handlerInstance respondsToSelector:dasSelector])
	{
		[handlerInstance performSelectorOnMainThread:dasSelector withObject:[KaiwaConversation conversationWithRequest:req andResponse:response forFriend:requestFriend] waitUntilDone:YES];
		result=YES;
	}
	
	if (persistsInstance==NO)
	{
		[handlerInstance release];
		handlerInstance=nil;
	}
	
	return result;
}


-(BOOL)invokeURI:(NSString *)uri withArguments:(NSArray *)arguments forFriend:(KaiwaFriend *)friend
{
	NSArray *matches=[routeRegex findAllInString:uri];
	if ([matches count]==0)
		return NO;
	
	if (handlerInstance==nil)
	{
		if (handlerClass==nil)
			return NO;
		
		handlerInstance=[[[handlerClass alloc] init] retain];
	}
	
	BOOL result=NO;
	
	//	SEL setReq=@selector(setRequest:);
	//	SEL setRes=@selector(setResponse:);
	//	
	//	if ([handlerInstance respondsToSelector:setReq])
	//		[handlerInstance performSelector:setReq withObject:req];
	//	if ([handlerInstance respondsToSelector:setRes])
	//		[handlerInstance performSelector:setRes withObject:response];
	
	
	// invoke
	SEL dasSelector=selector;
	if (dasSelector==nil)
	{
		NSString *method=nil;
		
		NSMutableArray *segments = [NSMutableArray array];
		NSScanner *scanner = [NSScanner scannerWithString:uri];
		[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
		while (![scanner isAtEnd]) {
			NSString *seg=@"";
			[scanner scanUpToString:@"/" intoString:&seg];
			[segments addObject:seg];
		}
		
		if ([segments count]<2)
			method=@"defaultAction:";
		else
			method=[[segments objectAtIndex:1] stringByAppendingString:@"Action:"];
		
		dasSelector=NSSelectorFromString(method);
	}
	
	if ([handlerInstance respondsToSelector:dasSelector])
	{
		[handlerInstance performSelectorOnMainThread:dasSelector withObject:[KaiwaShout shoutWithURI:uri withArguments:arguments forFriend:friend] waitUntilDone:NO];
		result=YES;
	}
	
	if (persistsInstance==NO)
	{
		[handlerInstance release];
		handlerInstance=nil;
	}
	
	return result;
}

@end
