//
//  HTTPCookie.h
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


@interface HTTPCookie : NSObject 
{
	NSString *name;
	NSString *value;
	NSString *comment;
	NSString *commentURL;
	NSString *domain;
	NSString *path;
	NSDate *expires;
}

#pragma mark properties

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *value;
@property (retain, nonatomic) NSString *comment;
@property (retain, nonatomic) NSString *commentURL;
@property (retain, nonatomic) NSString *domain;
@property (retain, nonatomic) NSDate *expires;
@property (retain, nonatomic) NSString *path;

#pragma mark initialization

-(id)initWithName:(NSString *)theName value:(NSString *)theValue expiresIn:(NSTimeInterval)seconds; 
-(id)initWithName:(NSString *)theName value:(NSString *)theValue date:(NSDate *)theDate path:(NSString *)thePath domain:(NSString *)theDomain; 

#pragma mark misc

-(void)deleteCookie;
-(NSString *)collapse;

#pragma mark static

+(NSDictionary *)cookiesFromHeader:(NSDictionary *)headers;

@end
