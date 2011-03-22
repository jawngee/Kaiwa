//
//  KaiwaTestPostController.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KaiwaTestPostController.h"


@implementation KaiwaTestPostController

-(void)resultAction
{
	[response writeLine:[request.query objectForKey:@"messageTo"]];
	[response writeLine:[request.query objectForKey:@"messageBody"]];
}

@end
