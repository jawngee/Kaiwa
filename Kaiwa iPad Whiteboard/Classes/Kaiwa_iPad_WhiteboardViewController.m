//
//  Kaiwa_iPad_WhiteboardViewController.m
//  Kaiwa iPad Whiteboard
//
//  Created by Jon Gilkison on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Kaiwa_iPad_WhiteboardViewController.h"
#import "RandomSequence.h"
#import "NSColor+Hex.h"

@implementation Kaiwa_iPad_WhiteboardViewController

-(void)awakeFromNib
{
	[super awakeFromNib];
	
	friends=[[NSMutableDictionary dictionaryWithCapacity:0] retain];
	
	dispatcher=[[KaiwaDispatcher alloc] initWithType:@"_kaiwaWhiteBoard._tcp" port:8181];
	dispatcher.delegate=self;
	dispatcher.OSCEnabled=YES;
	dispatcher.OSCPort=[RandomSequence randomValueBetweenLowerValue:16384 andUpperValue:32767];
	
	[dispatcher registerRoute:@"/command/(.*)" forInstance:self];
	
	[dispatcher start];
	
	[dispatcher findFriends];
}

#pragma mark -
#pragma mark Kaiwa protocols

-(void)foundFriend:(KaiwaFriend *)newFriend
{
	KWBuddy *buddy=[[KWBuddy alloc] initWithFriend:newFriend];
	[friends setObject:buddy forKey:newFriend.uid];
	
//	[newFriend ask:@"/command/userImage" withData:nil forBlock:^(BOOL success, id res){
//		buddy.image=[[[NSImage alloc] initWithData:res] autorelease];
//	}];
	
	NSLog(@"Found friend:%@",newFriend.url);
}

-(void)lostFriend:(KaiwaFriend *)oldFriend
{
	NSLog(@"Lost friend:%@",oldFriend.url);
	
	[friends removeObjectForKey:oldFriend.uid];
}


-(void)mouseDownAction:(KaiwaConversation *)convo
{
	float x=[[convo.request.query objectForKey:@"x"] floatValue];
	float y=[[convo.request.query objectForKey:@"y"] floatValue];
	float lineWidth=[[convo.request.query objectForKey:@"lineWidth"] floatValue];
	UIColor *lineColor=[UIColor colorFromHexString:[convo.request.query objectForKey:@"lineColor"]];
	
	[whiteBoard friendMouseDown:convo.friend x:x y:y lineWidth:lineWidth lineColor:lineColor];
}


-(void)mouseUpAction:(KaiwaConversation *)convo
{
	NSLog(@"MOUSE UP");
	float x=[[convo.request.query objectForKey:@"x"] floatValue];
	float y=[[convo.request.query objectForKey:@"y"] floatValue];
	
	[whiteBoard friendMouseUp:convo.friend x:x y:y];
}


-(void)mouseDraggedAction:(KaiwaShout *)shout
{
	float x=[[shout.arguments objectAtIndex:0] floatValue];
	float y=[[shout.arguments objectAtIndex:1] floatValue];
	
	[whiteBoard friendMouseDragged:shout.friend x:x y:y];
}

-(void)clearMineAction:(KaiwaConversation *)convo
{
	NSLog(@"CLEAR MINE");
	// they are asking to clear theirs when they call /command/clearMine
	[whiteBoard clearTheirs:convo.friend];
}

-(void)clearTheirsAction:(KaiwaConversation *)convo
{
	NSLog(@"CLEAR THEIRS");
	// they are asking to clear mine when they call /command/clearTheirs
	[whiteBoard clearMine];
}

-(void)clearAllAction:(KaiwaConversation *)convo
{
	NSLog(@"CLEAR ALL");
	[whiteBoard clearAll];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void)whiteBoardMouseDown:(CGPoint)point lineWidth:(float)lineWidth andColor:(UIColor *)color
{
	[dispatcher broadcastToFriends:@"/command/mouseDown" data:[NSDictionary dictionaryWithObjectsAndKeys:
															   [NSNumber numberWithFloat:point.x],@"x",
															   [NSNumber numberWithFloat:point.y],@"y",
															   [NSNumber numberWithFloat:lineWidth],@"lineWidth",
															   [color hexColorString],@"lineColor",
															   nil]];
}

-(void)whiteBoardMouseDragged:(CGPoint)point
{
	[dispatcher shoutToFriends:@"/command/mouseDragged" data:[NSArray arrayWithObjects:[NSNumber numberWithFloat:point.x],[NSNumber numberWithFloat:point.y],nil]];
}

-(void)whiteBoardMouseUp:(CGPoint)point
{
	NSLog(@"FRIEND MOUSE UP");
	[dispatcher broadcastToFriends:@"/command/mouseUp" data:[NSDictionary dictionaryWithObjectsAndKeys:
															 [NSNumber numberWithFloat:point.x],@"x",
															 [NSNumber numberWithFloat:point.y],@"y",
															 nil]];
}


@end
