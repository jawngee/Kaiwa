#import <Foundation/Foundation.h>
#import "HTTPResponse.h"

@class HTTPConnection;


@interface HTTPAsyncFileResponse : NSObject <HTTPResponse>
{
	NSMutableDictionary *headers;
	HTTPConnection *connection;
	NSThread *connectionThread;
	NSArray *connectionRunLoopModes;
	
	NSString *filePath;
	NSFileHandle *fileHandle;
	
	UInt64 fileLength;
	
	UInt64 fileReadOffset;
	UInt64 connectionReadOffset;
	
	NSData *data;
	
	BOOL asyncReadInProgress;
}

@property (readonly) NSMutableDictionary *headers;

- (id)initWithFilePath:(NSString *)filePath forConnection:(HTTPConnection *)connection runLoopModes:(NSArray *)modes;
- (NSString *)filePath;
- (void)setHeaders:(NSDictionary *)theHeaders;
- (NSDictionary *)httpHeaders;

@end
