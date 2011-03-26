
#import "OSCValue.h"




@implementation OSCValue


- (NSString *) description	{
	switch (type)	{
		case OSCValInt:
			return [NSString stringWithFormat:@"<OSCVal i %ld>",*(int *)value];
		case OSCValFloat:
			return [NSString stringWithFormat:@"<OSCVal f %f>",*(float *)value];
		case OSCValString:
			return [NSString stringWithFormat:@"<OSCVal s \"%@\">",(id)value];
		case OSCValColor:
			return [NSString stringWithFormat:@"<OSCVal r %@>",(id)value];
		case OSCValMIDI:
			return [NSString stringWithFormat:@"<OSCVal m %ld-%ld-%ld-%ld>",((Byte *)value)[0],((Byte *)value)[1],((Byte *)value)[2],((Byte *)value)[3]];
		case OSCValBool:
			if (*(BOOL *)value)
				return [NSString stringWithString:@"<OSCVal T>"];
			else
				return [NSString stringWithString:@"<OSCVal F>"];
		case OSCValNil:
			return [NSString stringWithFormat:@"<OSCVal nil>"];
		case OSCValInfinity:
			return [NSString stringWithFormat:@"<OSCVal infinity>"];
		case OSCValBlob:
			return [NSString stringWithFormat:@"<OSCVal blob: %@>",value];
	}
	return [NSString stringWithFormat:@"<OSCValue ?>"];
}
- (NSString *) lengthyDescription	{
#if !IPHONE
	float		colorComps[4];
#endif
	switch (type)	{
		case OSCValInt:
			return [NSString stringWithFormat:@"integer %ld",*(int *)value];
		case OSCValFloat:
			return [NSString stringWithFormat:@"float %f",*(float *)value];
		case OSCValString:
			return [NSString stringWithFormat:@"string \"%@\"",(id)value];
		case OSCValColor:
#if IPHONE
			return [NSString stringWithFormat:@"color %@",(id)value];
#else
			[(NSColor *)value getComponents:(CGFloat *)colorComps];
			return [NSString stringWithFormat:@"color %0.2f-%0.2f-%0.2f-%0.2f",colorComps[0],colorComps[1],colorComps[2],colorComps[3]];
#endif
			
		case OSCValMIDI:
			return [NSString stringWithFormat:@"MIDI %ld-%ld-%ld-%ld>",((Byte *)value)[0],((Byte *)value)[1],((Byte *)value)[2],((Byte *)value)[3]];
		case OSCValBool:
			if (*(BOOL *)value)
				return [NSString stringWithString:@"True"];
			else
				return [NSString stringWithString:@"False"];
		case OSCValNil:
			return [NSString stringWithFormat:@"nil"];
		case OSCValInfinity:
			return [NSString stringWithFormat:@"infinity"];
		case OSCValBlob:
			return [NSString stringWithFormat:@"<Data Blob>"];
	}
	return [NSString stringWithFormat:@"?"];
}


+ (id) createWithInt:(int)n	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithInt:n];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithFloat:(float)n	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithFloat:n];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithString:(NSString *)n	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithString:n];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithColor:(id)n	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithColor:n];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithMIDIChannel:(Byte)c status:(Byte)s data1:(Byte)d1 data2:(Byte)d2	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithMIDIChannel:c status:s data1:d1 data2:d2];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithBool:(BOOL)n	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithBool:n];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithNil	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithNil];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithInfinity	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithInfinity];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
+ (id) createWithNSDataBlob:(NSData *)d	{
	OSCValue		*returnMe = [[OSCValue alloc] initWithNSDataBlob:d];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}


- (id) initWithInt:(int)n	{
	if (self = [super init])	{
		value = malloc(sizeof(int));
		*(int *)value = n;
		type = OSCValInt;
		return self;
	}
	[self release];
	return nil;
}
- (id) initWithFloat:(float)n	{
	if (self = [super init])	{
		value = malloc(sizeof(float));
		*(float *)value = n;
		type = OSCValFloat;
		return self;
	}
	[self release];
	return nil;
}
- (id) initWithString:(NSString *)n	{
	if (n == nil)
		goto BAIL;
	if (self = [super init])	{
		value = [n retain];
		type = OSCValString;
		return self;
	}
	BAIL:
	NSLog(@"\t\terr: %s - BAIL",__func__);
	[self release];
	return nil;
}
- (id) initWithColor:(id)n	{
	if (n == nil)
		goto BAIL;
	if (self = [super init])	{
		value = [n retain];
		type = OSCValColor;
		return self;
	}
	BAIL:
	NSLog(@"\t\terr: %s - BAIL",__func__);
	[self release];
	return nil;
}
- (id) initWithMIDIChannel:(Byte)c status:(Byte)s data1:(Byte)d1 data2:(Byte)d2	{
	if (self = [super init])	{
		value = malloc(sizeof(Byte)*4);
		((Byte *)value)[0] = c;
		((Byte *)value)[1] = s;
		((Byte *)value)[2] = d1;
		((Byte *)value)[3] = d2;
		type = OSCValMIDI;
		return self;
	}
	[self release];
	return nil;
}
- (id) initWithBool:(BOOL)n	{
	if (self = [super init])	{
		value = malloc(sizeof(BOOL));
		*(BOOL *)value = n;
		type = OSCValBool;
		return self;
	}
	[self release];
	return nil;
}
- (id) initWithNil	{
	if (self = [super init])	{
		value = nil;
		type = OSCValNil;
		return self;
	}
	[self release];
	return nil;
}
- (id) initWithInfinity	{
	if (self = [super init])	{
		value = nil;
		type = OSCValInfinity;
		return self;
	}
	[self release];
	return nil;
}
- (id) initWithNSDataBlob:(NSData *)d	{
	if (d == nil)	{
		[self release];
		return nil;
	}
	if (self = [super init])	{
		value = [d retain];
		type = OSCValBlob;
		return self;
	}
	[self release];
	return nil;
}
- (id) copyWithZone:(NSZone *)z	{
	OSCValue		*returnMe = nil;
	switch (type)	{
		OSCValInt:
			returnMe = [[OSCValue allocWithZone:z] initWithInt:*((int *)value)];
			break;
		OSCValFloat:
			returnMe = [[OSCValue allocWithZone:z] initWithFloat:*((float *)value)];
			break;
		OSCValString:
			returnMe = [[OSCValue allocWithZone:z] initWithString:((NSString *)value)];
			break;
		OSCValTimeTag:
			NSLog(@"\tERR: TRIED TO COPY TIME TAG");
			break;
		OSCValChar:
			NSLog(@"\tERR: TRIED TO COPY CHAR");
			break;
		OSCValColor:
			returnMe = [[OSCValue allocWithZone:z] initWithColor:((id)value)];
			break;
		OSCValMIDI:
			returnMe = [[OSCValue allocWithZone:z]
				initWithMIDIChannel:*((Byte *)value+0)
				status:*((Byte *)value+1)
				data1:*((Byte *)value+2)
				data2:*((Byte *)value+3)];
			break;
		OSCValBool:
			returnMe = [[OSCValue allocWithZone:z] initWithBool:*((BOOL *)value)];
			break;
		OSCValNil:
			returnMe = [[OSCValue allocWithZone:z] initWithNil];
			break;
		OSCValInfinity:
			returnMe = [[OSCValue allocWithZone:z] initWithInfinity];
			break;
		OSCValBlob:
			returnMe = [[OSCValue allocWithZone:z] initWithNSDataBlob:value];
			break;
	}
	return returnMe;
}


- (void) dealloc	{
	switch (type)	{
		case OSCValInt:
		case OSCValBool:
		case OSCValFloat:
			if (value != nil)
				free(value);
			value = nil;
			break;
		case OSCValString:
		case OSCValColor:
			if (value != nil)
				[(id)value release];
			value = nil;
			break;
		case OSCValMIDI:
			if (value != nil)
				free(value);
			value = nil;
			break;
		case OSCValNil:
		case OSCValInfinity:
			break;
		case OSCValBlob:
			if (value != nil)
				[(NSData *)value release];
			value = nil;
			break;
	}
	value = nil;
	[super dealloc];
}


- (int) intValue	{
	return *(int *)value;
}
- (float) floatValue	{
	return *(float *)value;
}
- (NSString *) stringValue	{
	return (NSString *)value;
}
- (id) colorValue	{
	return (id)value;
}
- (Byte) midiPort	{
	return ((Byte *)value)[0];
}
- (VVOSCMIDIStatus) midiStatus	{
	return ((Byte *)value)[1];
}
- (Byte) midiData1	{
	return ((Byte *)value)[2];
}
- (Byte) midiData2	{
	return ((Byte *)value)[3];
}
- (BOOL) boolValue	{
	return *(BOOL *)value;
}
- (NSData *) blobNSData	{
	return (NSData *)value;
}


- (float) calculateFloatValue	{
	float		returnMe = 0.0;
	CGFloat		comps[4];
	switch (type)	{
		case OSCValInt:
			returnMe = (float)(*(int *)value);
			break;
		case OSCValFloat:
			returnMe = *(float *)value;
			break;
		case OSCValColor:
#if IPHONE
			*comps = *(CGColorGetComponents([(UIColor *)value CGColor]));
#else
			[(NSColor *)value getComponents:comps];
#endif
			returnMe = (comps[0]+comps[1]+comps[2])/3.0;
			break;
		case OSCValMIDI:
			//	if it's a MIDI-type OSC value, return the note velocity or the controller value
			switch ((VVOSCMIDIStatus)(((Byte *)value)[1]))	{
				case VVOSCMIDINoteOffVal:
				case VVOSCMIDIBeginSysexDumpVal:
				case VVOSCMIDIUndefinedCommon1Val:
				case VVOSCMIDIUndefinedCommon2Val:
				case VVOSCMIDIEndSysexDumpVal:
					returnMe = 0.0;
					break;
				case VVOSCMIDINoteOnVal:
				case VVOSCMIDIAfterTouchVal:
				case VVOSCMIDIControlChangeVal:
					returnMe = ((float)([self midiData2]))/127.0;
					break;
				case VVOSCMIDIProgramChangeVal:
				case VVOSCMIDIChannelPressureVal:
				case VVOSCMIDIMTCQuarterFrameVal:
				case VVOSCMIDISongSelectVal:
					returnMe = ((float)([self midiData1]))/127.0;
					break;
				case VVOSCMIDIPitchWheelVal:
				case VVOSCMIDISongPosPointerVal:
					returnMe = ((float)	((long)(([self midiData2] << 7) | ([self midiData1])))	)/16383.0;
					break;
				case VVOSCMIDITuneRequestVal:
				case VVOSCMIDIClockVal:
				case VVOSCMIDITickVal:
				case VVOSCMIDIStartVal:
				case VVOSCMIDIContinueVal:
				case VVOSCMIDIStopVal:
				case VVOSCMIDIUndefinedRealtime1Val:
				case VVOSCMIDIActiveSenseVal:
				case VVOSCMIDIResetVal:
					returnMe = 1.0;
					break;
			}
			break;
		case OSCValString:
			//	OSC STRINGS REQUIRE A NULL CHARACTER AFTER THEM!
			//return ROUNDUP4(([(NSString *)value length] + 1));
			break;
		case OSCValBool:
			returnMe = (*(BOOL *)value) ? 1.0 : 0.0;
			break;
		case OSCValNil:
			returnMe = 0.0;
			break;
		case OSCValInfinity:
			returnMe = 1.0;
			break;
		case OSCValBlob:
			returnMe = 1.0;
			break;
	}
	return returnMe;
}


@synthesize type;


- (int) bufferLength	{
	//NSLog(@"%s",__func__);
	switch (type)	{
		case OSCValInt:
		case OSCValFloat:
		case OSCValColor:
		case OSCValMIDI:
			return 4;
		break;
		case OSCValString:
			//	OSC STRINGS REQUIRE A NULL CHARACTER AFTER THEM!
			return ROUNDUP4((strlen([(NSString *)value UTF8String]) + 1));
			break;
		case OSCValBool:
		case OSCValNil:
		case OSCValInfinity:
			return 0;
			break;
		case OSCValBlob:
			if (value == nil)
				return 0;
			//	BLOBS DON'T REQUIRE A NULL CHARACTER AFTER THEM!
			return ROUNDUP4((4 + [(NSData *)value length]));
			break;
	}
	return 0;
}
- (void) writeToBuffer:(unsigned char *)b typeOffset:(int *)t dataOffset:(int *)d	{
	//NSLog(@"%s",__func__);
	
	int					i;
	long				tmpLong = 0;
	float				tmpFloat = 0.0;
	unsigned char		*charPtr = NULL;
	void				*voidPtr = NULL;
	unsigned char		tmpChar = 0;
#if IPHONE
	CGColorRef			tmpColor;
	const CGFloat		*tmpCGFloatPtr;
#endif
	
	switch (type)	{
		case OSCValInt:
			tmpLong = *(int *)value;
			tmpLong = htonl(tmpLong);
			
			for (i=0; i<4; ++i)
				b[*d+i] = 255 & (tmpLong >> (i*8));
			*d += 4;
			
			b[*t] = 'i';
			++*t;
			break;
		case OSCValFloat:
			tmpFloat = *(float *)value;
			tmpLong = htonl(*((long *)(&tmpFloat)));
			strncpy((char *)(b+*d), (char *)(&tmpLong), 4);
			*d += 4;
			
			b[*t] = 'f';
			++*t;
			break;
		case OSCValString:
			tmpLong = strlen([(NSString *)value UTF8String]);
			charPtr = (unsigned char *)[(NSString *)value UTF8String];
			strncpy((char *)(b+*d),(char *)charPtr,tmpLong);
			*d = *d + tmpLong + 1;
			*d = ROUNDUP4(*d);
			
			b[*t] = 's';
			++*t;
			break;
		case OSCValColor:
#if IPHONE
			tmpColor = [(UIColor *)value CGColor];
			tmpCGFloatPtr = CGColorGetComponents(tmpColor);
			for (i=0;i<4;++i)	{
				tmpChar = *(tmpCGFloatPtr + i) * 255.0;
				b[*d+i] = tmpChar;
			}
#else
			tmpChar = [(NSColor *)value redComponent] * 255.0;
			b[*d] = tmpChar;
			tmpChar = [(NSColor *)value greenComponent] * 255.0;
			b[*d+1] = tmpChar;
			tmpChar = [(NSColor *)value blueComponent] * 255.0;
			b[*d+2] = tmpChar;
			tmpChar = [(NSColor *)value alphaComponent] * 255.0;
			b[*d+3] = tmpChar;
#endif
			*d += 4;
			
			b[*t] = 'r';
			++*t;
			break;
		case OSCValMIDI:
			memcpy(b+*d, value, sizeof(Byte)*4);
			*d += 4;
			
			b[*t] = 'm';
			++*t;
			break;
		case OSCValBool:
			if (*(BOOL *)value)
				b[*t] = 'T';
			else
				b[*t] = 'F';
			++*t;
			break;
		case OSCValNil:
			break;
		case OSCValInfinity:
			break;
		case OSCValBlob:
			//	calculate the size of the blob, write it to the buffer
			tmpLong = [(NSData *)value length];
			tmpLong = htonl(tmpLong);
			for (i=0;i<4;++i)
				b[*d+i] = 255 & (tmpLong >> (i*8));
			*d += 4;
			//	now write the actual contents of the blob to the buffer
			tmpLong = [(NSData *)value length];
			voidPtr = (void *)[(NSData *)value bytes];
			memcpy((void *)(b+*d),(void *)voidPtr,tmpLong);
			*d = *d + tmpLong;
			*d = ROUNDUP4(*d);
			b[*t] = 'b';
			++*t;
			break;
	}
	
}


@end
