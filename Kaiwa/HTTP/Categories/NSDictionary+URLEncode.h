//
//  NSDictionary+URLEncode.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/18/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDictionary(URLEncode)

+(NSDictionary *)parsedQuery:(NSString *)queryString;
-(NSString *)urlEncoded;

@end
