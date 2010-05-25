//
//  KaiwaRoute.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/19/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KaiwaRequest.h"
#import "KaiwaResponse.h"
#import "AGRegex.h"


/**
 Represents a route mapping an incoming uri to a class and appropriate selector.
 */
@interface KaiwaRoute : NSObject
{
	NSString *route;			/**< The route regex string */
	AGRegex *routeRegex;		/**< The compiled regex */
	Class handlerClass;		/**< The class to map the route to */
	SEL selector;				/**< The selector to invoke for the route */
	id handlerInstance;		/**< The instance to map the route to */
	BOOL persistsInstance;	/**< Controls if instances are persisted between request */
}

/**
 Creates a new route, mapped to an existing instance.
 @param theRoute The regex to match for the route
 @param theInstance The instance to map to
*/
-(id)initWithRoute:(NSString *)theRoute forInstance:(id)theInstance;

/**
 Creates a new route, mapped to an existing instance and selector.
 @param theRoute The regex to match for the route
 @param theInstance The instance to map to
 @param theSelector The selector to invoke
 */
-(id)initWithRoute:(NSString *)theRoute forInstance:(id)theInstance andSelector:(SEL)theSelector;

/**
 Creates a new route, mapped to a class.
 @param theRoute The regex to match for the route
 @param theClass The class to map the route to
 @param isPersistant Contols if instances of the class are persisted between requests
*/
-(id)initWithRoute:(NSString *)theRoute forClass:(Class)theClass persistInstance:(BOOL)isPersistant;

/**
 Creates a new route, mapped to a class and a selector.
 @param theRoute The regex to match for the route
 @param theClass The class to map the route to
 @param theSelector The selector to invoke
 @param isPersistant Contols if instances of the class are persisted between requests
 */
-(id)initWithRoute:(NSString *)theRoute forClass:(Class)theClass andSelector:(SEL)theSelector persistInstance:(BOOL)isPersistant;

/**
 Invokes the route
 @param req A KaiwaRequest instance
 @param response A KaiwaResponse instance
*/
-(BOOL)invoke:(KaiwaRequest *)req forResponse:(KaiwaResponse *)response;

@end
