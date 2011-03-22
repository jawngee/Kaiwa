//
//  HTTPCookie.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTTPCookie.h"
#import "NSString+URLEncode.h"

@implementation HTTPCookie

@synthesize name, value, comment, commentURL, domain, expires, path;

#pragma mark initialization

-(id)init
{
	if ((self=[super init]))
	{
		name=nil;
		value=nil;
		comment=nil;
		commentURL=nil;
		domain=nil;
		expires=nil;
		path=nil;
	}
	
	return self;
}

-(id)initWithName:(NSString *)theName value:(NSString *)theValue expiresIn:(NSTimeInterval)seconds
{
	if ((self=[self init]))
	{
		name=[theName retain];
		value=[theValue retain];
		path=@"/";
		expires=[[NSDate dateWithTimeIntervalSinceNow:seconds] retain];
	}
	
	return self;
}

-(id)initWithName:(NSString *)theName value:(NSString *)theValue date:(NSDate *)theDate path:(NSString *)thePath domain:(NSString *)theDomain
{
	if ((self=[self init]))
	{
		name=[theName retain];
		value=[theValue retain];
		path=thePath;
		domain=theDomain;
		expires=[theDate retain];
	}
	
	return self;
}

-(void)dealloc
{
	if (name!=nil) [name release];
	if (value!=nil) [value release];
	if (comment!=nil) [comment release];
	if (commentURL!=nil) [commentURL release];
	if (domain!=nil) [domain release];
	if (expires!=nil) [expires release];
	if (path!=nil) [path release];
	
	[super dealloc];
}

#pragma mark misc

-(void)deleteCookie
{
	if (expires!=nil) [expires release];
	expires=[NSDate distantPast];
}

-(NSString *)collapse
{
	if ((name==nil) || (value==nil))
		return nil;
	
	NSString *result=[NSString stringWithFormat:@"%@=%@",[name urlEncoded],[value urlEncoded]];
	
	if (expires!=nil)
	{
		NSString *expireStr=[expires descriptionWithCalendarFormat:@"%a, %d-%b-%Y %H:%M:%S GMT" timeZone:[NSTimeZone timeZoneWithName:@"GMT"] locale:nil];
		result=[result stringByAppendingFormat:@"; expires:%@",expireStr];
	}

	if (domain!=nil)
	{
		if ([domain hasPrefix:@"."]==NO)
		{
			NSString *oldDomain=domain;
			domain=[[NSString stringWithFormat:@".%@",domain] retain];
			[oldDomain release];
		}
		
		result=[result stringByAppendingFormat:@"; domain=%@",domain];
	}
	
	if (path!=nil)
		result=[result stringByAppendingFormat:@"; path=%@",path];
	
	if (comment!=nil)
		result=[result stringByAppendingFormat:@"; comment=%@",comment];

	if (commentURL!=nil)
		result=[result stringByAppendingFormat:@"; commentURL=\"%@\"",commentURL];

	return result;	
}

#pragma mark statics




+(NSDictionary *)cookiesFromHeader:(NSDictionary *)headers
{
	NSMutableDictionary *cookies=[[NSMutableDictionary dictionary] retain];
	
	NSString *cookiesString=[headers objectForKey:@"Cookie"];
	if (cookiesString==nil)
		return cookies;
	
	NSArray *cookieParts=[cookiesString componentsSeparatedByString:@";"];
	for(NSString *cookieSt in cookieParts)
	{
		NSArray *vals=[cookieSt componentsSeparatedByString:@"="];
		if ([vals count]==2)
		{
			HTTPCookie *cookie=[[HTTPCookie alloc] init];
			cookie.name=[vals objectAtIndex:0];
			cookie.value=[vals objectAtIndex:1];
			[cookies setObject:cookie forKey:cookie.name];
		}
	}
	
	return cookies;
}

@end
