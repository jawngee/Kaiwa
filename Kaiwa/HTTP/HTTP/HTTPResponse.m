#import "HTTPResponse.h"


@implementation HTTPFileResponse

@synthesize headers;

- (id)initWithFilePath:(NSString *)filePathParam
{
	if((self = [super init]))
	{
		headers=[[NSMutableDictionary dictionary] retain];
		filePath = [filePathParam copy];
		fileHandle = [[NSFileHandle fileHandleForReadingAtPath:filePath] retain];
		
		if(fileHandle == nil)
		{
			[self release];
			return nil;
		}
		
		NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:filePath traverseLink:NO];
		NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
		fileLength = (UInt64)[fileSize unsignedLongLongValue];
	}
	return self;
}

- (void)dealloc
{
	[headers release];
	[filePath release];
	[fileHandle closeFile];
	[fileHandle release];
	[super dealloc];
}

- (UInt64)contentLength
{
	return fileLength;
}

- (UInt64)offset
{
	return (UInt64)[fileHandle offsetInFile];
}

- (void)setOffset:(UInt64)offset
{
	[fileHandle seekToFileOffset:offset];
}

- (NSData *)readDataOfLength:(unsigned int)length
{
	return [fileHandle readDataOfLength:length];
}

- (BOOL)isDone
{
	return ([fileHandle offsetInFile] == fileLength);
}

- (NSString *)filePath
{
	return filePath;
}

- (void)setHeaders:(NSDictionary *)theHeaders
{
	if (headers!=nil)
		[headers release];
	
	headers=[theHeaders mutableCopy];
}

- (NSDictionary *)httpHeaders
{
	return headers;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation HTTPDataResponse

@synthesize headers;

- (id)initWithData:(NSData *)dataParam
{
	if((self = [super init]))
	{
		offset = 0;
		data = [dataParam retain];
		headers=[[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void)dealloc
{
	[headers release];
	[data release];
	[super dealloc];
}

- (UInt64)contentLength
{
	return (UInt64)[data length];
}

- (UInt64)offset
{
	return offset;
}

- (void)setOffset:(UInt64)offsetParam
{
	offset = offsetParam;
}

- (NSData *)readDataOfLength:(unsigned int)lengthParameter
{
	unsigned int remaining = [data length] - offset;
	unsigned int length = lengthParameter < remaining ? lengthParameter : remaining;
	
	void *bytes = (void *)([data bytes] + offset);
	
	offset += length;
	
	return [NSData dataWithBytesNoCopy:bytes length:length freeWhenDone:NO];
}

- (BOOL)isDone
{
	return (offset == [data length]);
}

- (void)setHeaders:(NSDictionary *)theHeaders
{
	if (headers!=nil)
		[headers release];
	
	headers=[theHeaders mutableCopy];
}

- (NSDictionary *)httpHeaders
{
	return headers;
}

@end
