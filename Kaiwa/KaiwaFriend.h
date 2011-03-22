//
//  KaiwaFriend.h
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 Represents a "friend", aka an application that implements whatever
 application defined interface
*/
@interface KaiwaFriend : NSObject 
{
	NSNetService *service;  /**< The service */
	NSString *url;				/**< The url of the friend */
	NSString *host;			/**< The host */
	NSInteger port;			/**< The port */
	NSString *user;			/**< The user */
	NSString *machine;		/**< The machine */
	NSString *app;				/**< The name of the app */
	NSString *appVersion;	/**< The current app version */
}

@property (readonly) NSNetService *service;  /**< The service */
@property (readonly) NSString *url;				/**< The url of the friend */
@property (readonly) NSString *host;			/**< The host */
@property (readonly) NSInteger port;			/**< The port */
@property (readonly) NSString *user;			/**< The user */
@property (readonly) NSString *machine;		/**< The machine */
@property (readonly) NSString *app;				/**< The name of the app */
@property (readonly) NSString *appVersion;	/**< The current app version */

/**
 Creates a new instance of the friend using the resolved service
*/
-(id)initWithService:(NSNetService *)theService;

/**
 Creates a new instance of the friend using a host and port
 */
-(id)initWithHost:(NSString *)theHost port:(NSInteger)thePort;

/**
 Invokes a uri on the friend POSTing the data.  Is async and offers no response.
 */
-(void)tell:(NSString *)uri withData:(NSDictionary *)data;

/**
 Invokes a uri on the friend POSTint the data.  The response depends on the
 content-type of the response.  For xml, returns an XMLDocument.  For JSON,
 returns an NSDictionary or NSArrary.  For all other content types, returns
 a string.
*/
-(id)ask:(NSString *)uri withData:(NSDictionary *)data;

@end