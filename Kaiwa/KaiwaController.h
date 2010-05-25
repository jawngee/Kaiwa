//
//  KaiwaController.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KaiwaRequest.h"
#import "KaiwaResponse.h"

/**
 Protocol for implementing a Kaiwa controller
*/
@protocol KaiwaControllerProtocol

/**
 Assigns the KaiwaRequest instance
 @param theRequest The KaiwaRequest instance
*/
-(void)setRequest:(KaiwaRequest *)theRequest;

/**
 Assigns the KaiwaResponse instance
 @param theRequest The KaiwaResponse instance
 */
-(void)setResponse:(KaiwaResponse *)theResponse;

@end


/**
 Controller super class
*/
@interface KaiwaController : NSObject<KaiwaControllerProtocol> 
{
	KaiwaRequest *request;		/**< An instance of KaiwaRequest */
	KaiwaResponse *response;	/**< An instance of KaiwaResponse */
}

/**
 Assigns the KaiwaRequest instance
 @param theRequest The KaiwaRequest instance
 */
-(void)setRequest:(KaiwaRequest *)theRequest;

/**
 Assigns the KaiwaRequest instance
 @param theRequest The KaiwaRequest instance
 */
-(void)setResponse:(KaiwaResponse *)theResponse;

@end
