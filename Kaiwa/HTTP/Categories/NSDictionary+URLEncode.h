//
//  NSDictionary+URLEncode.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


@interface NSDictionary(URLEncode)

+(NSMutableDictionary *)parsedQuery:(NSString *)queryString;
-(NSString *)urlEncoded;

@end
