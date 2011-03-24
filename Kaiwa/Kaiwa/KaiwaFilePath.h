//
//  KaiwaFilePath.h
//  Kaiwa
//
//  Created by Jon Gilkison on 5/20/10.
//  Copyright 2010 Interfacelab LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KaiwaRewrite.h"

/**
 Maps a URI to a physical file or path
*/
@interface KaiwaFilePath : KaiwaRewrite 
{
}

/**
 Creates a new file mapping
 @param uriBase The base URI
 @param filePath The file path to map to
 @param isFile Controls if this mapping is to an actual file or to a directory.
*/
-(id)initWithURIBase:(NSString *)uriBase forPath:(NSString*)filePath isFile:(BOOL)isFile;

/**
 Determines if the URI exists in this mapping
 @param uri The URI to test
*/
-(NSString *)exists:(NSString*)uri;

@end
