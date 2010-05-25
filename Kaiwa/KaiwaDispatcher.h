//
//  KaiwaDispatcher.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTTPServer.h"
#import "HTTPResponse.h"
#import "HTTPConnection.h"

@class KaiwaConnection;
@class KaiwaFriend;

/**
 Delegate protocol for friend finding
*/
@protocol KaiwaFinderProtocol

/**
 Called when a friendly service has been found.
 @param newFriend An instance of KaiwaFriend of the newly found friend.
*/
-(void)foundFriend:(KaiwaFriend *)newFriend;

/**
 Called when a friendly service has been lost to the ether.
 @param newFriend The instance of KaiwaFriend that has been lost.
 */
-(void)lostFriend:(KaiwaFriend *)oldFriend;

@end


/**
 The KaiwaDispatcher is a singleton object responsible for setting up routes and dispatching
 incoming HTTP requests to the appropriate places.
*/
@interface KaiwaDispatcher : NSObject 
{
	NSMutableArray *routes;			/**< Array of KaiwaRoute instances */
	NSMutableArray *rewrites;		/**< Array of KaiwaRewrite rules */
	NSMutableArray *filePaths;		/**< Array of mapped file paths */
	
	NSString *name;					/**< The name of your service */
	NSString *type;					/**< The bonjour type, eg _http._tcp */
	NSInteger port;					/**< The port to run the server on */
	
	HTTPServer *httpServer;			/**< An instance of HTTPServer */
	
	NSNetServiceBrowser *serviceBrowser;	/**< Service browser for finding friends **/
	id<KaiwaFinderProtocol> friendFinder;	/**< Friend finder delegate **/
	NSMutableArray *friends;					/**< Array of friends */
	NSMutableArray *friendServices;			/**< Array of friend services */
}

/**
 Returns the singleton instance of the dispatcher
*/
+(KaiwaDispatcher *)dispatcher;

#pragma mark rewrites

/**
 Registers a rewrite rule.
 @param fromRegex The regex pattern to match for the rewrite
 @param replacement The replacement string
*/
+(void)registerRewrite:(NSString *)fromRegex to:(NSString *)replacement;

#pragma mark routes

/**
 Registers a route for an object instance.
 @param route The regex pattern to match on the incoming URI
 @param theInstance The instance to route the incoming request to
*/
+(void)registerRoute:(NSString *)route forInstance:(id)theInstance;

/**
 Registers a route for an object instance and a specific selector.
 @param route The regex pattern to match on the incoming URI
 @param theInstance The instance to route the incoming request to
 @param theSelector The selector to invoke on the instance for the given route.
 */
+(void)registerRoute:(NSString *)route forInstance:(id)theInstance andSelector:(SEL)theSelector;

/**
 Registers a route for a class.  Whenever this route is activated, it will create a new instance of
 the class (optionally keeping it in memory) and then route the incoming request to it.
 @param route The regex pattern to match on the incoming URI
 @param theClass The class that handles the route
 @param isPersistant Controls whether or not instances of the class are persisted from request to request.
 */
+(void)registerRoute:(NSString *)route forClass:(Class)theClass persistInstance:(BOOL)isPersistant;

/**
 Registers a route for a class and a specific selector.  Whenever this route is activated, it will create 
 a new instance of the class (optionally keeping it in memory) and then route the incoming request to it.
 @param route The regex pattern to match on the incoming URI
 @param theClass The class that handles the route
 @param theSelector The selector to invoke
 @param isPersistant Controls whether or not instances of the class are persisted from request to request.
 */
+(void)registerRoute:(NSString *)route forClass:(Class)theClass andSelector:(SEL)theSelector persistInstance:(BOOL)isPersistant;

#pragma mark URI

/**
 Maps an incoming URI to a specific file on the file system.
 @param uri The URI to map to
 @param theFile The full path and filename of the file.
*/
+(void)registerURI:(NSString *)uri forFile:(NSString *)theFile;

/**
 Maps an incoming URI to a specific path on the file system.
 @param uri The URI to map to
 @param thePath The full path on the file system to map to.
 */
+(void)registerURI:(NSString *)uri forPath:(NSString *)thePath;

#pragma mark start/stop

/**
 Starts the server
*/
+(void)start;

/**
 Starts the server, allowing you to specify the name, type and port.
 @param theName The name of the service
 @param theType The bonjour type
 @param atPort The port number
*/
+(void)startWithName:(NSString *)theName andType:(NSString *)theType atPort:(NSInteger)thePort;

/**
 Stops the server
*/
+(void)stop;

/**
 Dispatches a URI
 @param uri The URI to dispatch to
 @param method The HTTP method (GET, POST, PUT, DELETE, etc.)
 @param connection An instance of KaiwaConnection associated with the URI
*/
+(NSObject<HTTPResponse> *)dispatch:(NSString*)uri forMethod:(NSString *)method withConnection:(KaiwaConnection *)connection;

#pragma mark friends

/**
 Searches for friends (other kaiwa services)
 @param finderDelegate The delegate that will be notified when a new friend has been found.
*/
+(void)searchForFriends:(id<KaiwaFinderProtocol>)finderDelegate;

+(NSArray *)friends;

/**
 Broadcasts a message to friends.  Note that there is no ability to handle a response.  To do that, interface with
 friends on a per friend basis.
 @param uri The uri to broadcast to, eg /do/something
*/
+(void)broadcastToFriends:(NSString*)uri;



@end
