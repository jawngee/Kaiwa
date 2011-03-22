//
//  KaiwaFriendController.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KaiwaFriendController.h"
#import "JSON.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation KaiwaFriendController

-(void)infoAction
{
	NSString *username=NSFullUserName();
	
	CFStringRef name;
	NSString *computerName;
	name=SCDynamicStoreCopyComputerName(NULL,NULL);
	computerName=[NSString stringWithString:(NSString *)name];
	CFRelease(name);
	
	NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
	NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];

	
	NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:username,@"user",computerName,@"computer",appName,@"application",appVersion,@"version",nil];
	[response setContentType:@"text/json"];
	[response write:[dict JSONRepresentation]];
}

@end
