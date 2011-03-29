//
//  NSColor+Hex.m
//  KaiwaFramework
//
//  Created by Jon Gilkison on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSColor+Hex.h"


@implementation NSColor(HEX)


-(NSString *)hexColorString
{
	NSColor* col = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	return [NSString stringWithFormat:@"%0.2X%0.2X%0.2X",
			(int)([col redComponent] * 255),
			(int)([col greenComponent] * 255),
			(int)([col blueComponent] * 255)];
}

+(NSColor *)colorFromHexString:(NSString*)hex
{
	NSColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != hex)
	{
		NSScanner *scanner = [NSScanner scannerWithString:hex];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSColor
			  colorWithCalibratedRed:		(float)redByte	/ 0xff
			  green:	(float)greenByte/ 0xff
			  blue:	(float)blueByte	/ 0xff
			  alpha:1.0];
	return result;
}


@end
