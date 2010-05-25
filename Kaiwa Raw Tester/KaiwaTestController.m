//
//  KaiwaTestController.m
//  Kaiwa Raw Tester
//
//  Created by Jon Gilkison on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KaiwaTestController.h"


@implementation KaiwaTestController

-(void)defaultAction
{
	[response writeLine:@"default"];
}

-(void)anotherAction
{
	[response writeLine:@"another"];
}

-(void)listAction
{
	[response writeLine:@"list"];
}



@end
