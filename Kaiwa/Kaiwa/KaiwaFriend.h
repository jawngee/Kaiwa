//
//  KaiwaFriend.h
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/24/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
#import "KaiwaDispatcher.h"
#import "VVOSC.h"

/**
 Block def to call when asking a friend something.
 */
typedef void(^AskBlock)(BOOL success, id response);

@class KaiwaFriend;

/**
 Delegate for asking
 */
@protocol KaiwaAskDelegate

-(void)replyFrom:(KaiwaFriend *)afriend with:(id)response;
-(void)errorFrom:(KaiwaFriend *)afriend error:(id)error;

@end


/**
 Represents a "friend", aka an application that implements whatever
 application defined interface
*/
@interface KaiwaFriend : NSObject 
{
	KaiwaDispatcher *dispatcher;
	NSNetService *service;		/**< The service */
	NSString *url;				/**< The url of the friend */
	NSString *host;				/**< The host */
	NSInteger port;				/**< The port */
	NSString *user;				/**< The user */
	NSString *machine;			/**< The machine */
	NSString *app;				/**< The name of the app */
	NSString *appVersion;		/**< The current app version */
	NSString *uid;				/**< The friend's UID */
	
	OSCOutPort *outPort;		/**< The friend's OSC outport */
}

@property (readonly) KaiwaDispatcher *dispatcher;	/**< The dispatcher */
@property (readonly) NSNetService *service;			/**< The service */
@property (retain, nonatomic) NSString *url;					/**< The url of the friend */
@property (assign, nonatomic) NSString *host;				/**< The host */
@property (assign, nonatomic) NSInteger port;				/**< The port */
@property (retain, nonatomic) NSString *user;				/**< The user */
@property (retain, nonatomic) NSString *machine;				/**< The machine */
@property (retain, nonatomic) NSString *app;					/**< The name of the app */
@property (retain, nonatomic) NSString *appVersion;			/**< The current app version */
@property (retain, nonatomic) NSString *uid;					/**< The friend's UID */
@property (readonly) OSCOutPort *outPort;			/**< The friend's OSC outport */


/**
 Creates a new instance of the friend using the resolved service
*/
-(id)initWithService:(NSNetService *)theService dispatcher:(KaiwaDispatcher *)theDispatcher;

/**
 Creates a new instance of the friend using a host and port
 */
-(id)initWithHost:(NSString *)theHost port:(NSInteger)thePort dispatcher:(KaiwaDispatcher *)theDispatcher;

/**
 Invokes a uri on the friend POSTing the data.  Is async and offers no response.
 */
-(void)tell:(NSString *)uri withData:(NSDictionary *)data;

/**
 Invokes a uri on the friend via OSC.  Is async and offers no response.
 */
-(void)shout:(NSString *)uri withData:(NSArray *)data;


/**
 Invokes a uri on the friend POSTing the data.  The response depends on the
 content-type of the response.  For xml, returns an XMLDocument.  For JSON,
 returns an NSDictionary or NSArrary.  For all other content types, returns
 a string.
 
 This is synchronous.
 */
-(id)demand:(NSString *)uri withData:(NSDictionary *)data;


/**
 Invokes a uri on the friend POSTing the data.  The response depends on the
 content-type of the response.  For xml, returns an XMLDocument.  For JSON,
 returns an NSDictionary or NSArrary.  For all other content types, returns
 a string.
 
 This is asynchronous.  When the block is called it may not be on the 
 main thread.
 */
-(void)ask:(NSString *)uri withData:(NSDictionary *)data forBlock:(AskBlock)askBlock;


/**
 Invokes a uri on the friend POSTing the data.  The response depends on the
 content-type of the response.  For xml, returns an XMLDocument.  For JSON,
 returns an NSDictionary or NSArrary.  For all other content types, returns
 a string.
 
 This is asynchronous.  When the delegate is called it may not be on the 
 main thread.
 */
-(void)ask:(NSString *)uri withData:(NSDictionary *)data forDelegate:(id<KaiwaAskDelegate>)delegate;

/**
 When a dispatcher detects a new friend, it will ask it send information about
 itself.  This method is meant for subclasses of KaiwaFriend to pluck out any
 custom data they've defined.
 @param info The information dictionary
 */
-(void)applyInfo:(NSDictionary *)info;

@end