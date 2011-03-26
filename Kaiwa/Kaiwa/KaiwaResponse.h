//
//  KaiwaResponse.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPResponse.h"
#import "HTTPCookie.h"

@class KaiwaConnection;

/**
 Represents an interface for sending a response to an incoming request.
*/
@interface KaiwaResponse : NSObject 
{
	NSMutableArray *cookies;		/**< Array of cookies */
	NSMutableDictionary *headers;	/**< Array of outgoing headers */
	NSMutableData *output;			/**< Buffer to hold all output */
	NSString *contentType;			/**< The content type of the response */
	BOOL canWrite;					/**< Indicates that response allows writing */
	NSString *filePath;				/**< The full path and filename of a file to be sent in lieu of output */
	KaiwaConnection *connection;	/**< Instance of KaiwaConnection */
}

@property (readonly) NSMutableArray *cookies;
@property (readonly) NSMutableDictionary *headers;


/**
 Adds a cookie, setting the proper domain.
 @param cookie The cookie to add
 */
-(void)addCookie:(HTTPCookie *)cookie;

/**
 Initializes a new response
 @param theConnection An instance of KaiwaConnection
*/
-(id)initWithConnection:(KaiwaConnection *)theConnection;

/**
 Sets the content type of the response.  The default is 'text/xml'.
 @param newContentType The new content type
*/
-(void)setContentType:(NSString *)newContentType;

/**
 Writes text to the output buffer
 @param text The text to write
*/
-(void)write:(NSString*)text;

/**
 Writes text to the output buffer, appending a new line.
 @param text The text to write
*/
-(void)writeLine:(NSString*)text;

/**
 Sends a file to the output.  Note that any output written prior to calling this
 will not be sent.
 @param theFilePath The full path and filename of the file to send to the client
*/
-(void)sendFile:(NSString*)theFilePath;

/**
 Sends data to the output.  Note that any output written prior to calling this
 will not be sent.
 @param theData NSData to send
 */
-(void)sendData:(NSData*)theData;

/**
 Fetches an appropriate HTTPResponse
*/
-(NSObject<HTTPResponse> *)httpResponse;

@end
