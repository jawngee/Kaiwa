//
//  KaiwaRequest.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KaiwaConnection;

/**
 Represents all the information associated with an incoming request.
*/
@interface KaiwaRequest : NSObject 
{
	NSArray *headers;					/**< Array of headers - NOT IMPLEMENTED */
	NSArray *cookies;					/**< Array of cookies - NOT IMPLEMENTED */
	NSString *uri;						/**< The URI of the request */
	NSURL *url;							/**< The NSURL of the request */
	NSMutableDictionary *query;	/**< Dictionary of all query string parameters */
	NSString *method;					/**< The HTTP method */

	KaiwaConnection *connection;	/**< The associated KaiwaConnection */
}

@property (retain, nonatomic) NSArray *args;
@property (readonly) NSArray *headers;
@property (readonly) NSArray *cookies;
@property (readonly) NSMutableDictionary *query;
@property (readonly) NSString *method;
@property (readonly) NSString *uri;
@property (readonly) NSURL *url;

/**
 Initializes a new request
 @param uriString The URI
 @param theMethod The HTTP method
 @param theConnection An instance of KaiwaConnection
*/
-(id)initWithURIString:(NSString*)uriString forMethod:(NSString *)theMethod withConnection:(KaiwaConnection *)theConnection;

@end
