//
//  KMBuddy.h
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "Kaiwa.h"

@interface KWBuddy : NSObject {
	KaiwaFriend *friend;
	NSString *userName;
	UIImage *image;
}


@property (retain, nonatomic) KaiwaFriend *friend;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) UIImage *image;


-(id)initWithFriend:(KaiwaFriend *)afriend;

@end
