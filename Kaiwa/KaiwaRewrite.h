//
//  KaiwaRewrite.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGRegex.h"

/**
 Represents a URI rewrite, transforming an incoming URI to another.
*/
@interface KaiwaRewrite : NSObject 
{
	NSString *rewriteString;
	AGRegex *rewriteRegex;	/**< The rewrite regex*/
	NSString *rewriteSub;	/**< The substitution string */

}

/**
 Creates a new rewrite rule
 @param rewrite The regex to match
 @param rewriteTo The substitution string
*/
-(id)initWithRewrite:(NSString *)rewrite to:(NSString*)rewriteTo;

/**
 Performs the rewrite.  If not a match, returns the input.
 @param input The string to rewrite
*/
-(NSString *)rewrite:(NSString *)input;


@end
