//
//  RootViewController.m
//  Kaiwa iPad Messenger
//
//  Created by Jon Gilkison on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "KMBuddy.h"


@implementation RootViewController

@synthesize detailViewController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	friends=[[NSMutableArray arrayWithCapacity:0] retain];
	
	dispatcher=[[KaiwaDispatcher alloc] initWithType:@"_kaiwaMessenger._tcp" port:8181];
	dispatcher.delegate=self;
	
	[dispatcher registerRoute:@"/command/(.*)" forInstance:self];
	
	[dispatcher start];
	
	[dispatcher findFriends];
}

#pragma mark -
#pragma mark Kaiwa protocols

-(void)foundFriend:(KaiwaFriend *)newFriend
{
	KMBuddy *buddy=[[KMBuddy alloc] initWithFriend:newFriend];
	[friends addObject:buddy];
	
	[newFriend ask:@"/command/userImage" withData:nil forBlock:^(BOOL success, id res){
		buddy.image=[[[UIImage alloc] initWithData:res] autorelease];
	}];
	
	NSLog(@"Found friend:%@",newFriend.url);
	
	[self.tableView reloadData];
}

-(void)lostFriend:(KaiwaFriend *)oldFriend
{
	NSLog(@"Lost friend:%@",oldFriend.url);
	
	for(KMBuddy *buddy in friends)
		if ([buddy.friend.url isEqualToString:oldFriend.url])
		{
			[friends removeObject:buddy];
			break;
		}
	
	
	[self.tableView reloadData];
}

-(void)messageAction:(KaiwaConversation *)convo
{
	KMBuddy *buddy=nil;
	
	for(KMBuddy *bud in friends)
		if ([bud.friend.url isEqualToString:convo.friend.url])
		{
			buddy=bud;
			break;
		}
	
	if (buddy==detailViewController.detailItem)
	{
		NSString *message=[convo.request.query objectForKey:@"message"];
		[detailViewController addMessage:message];
	}
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = [[friends objectAtIndex:[indexPath row]] userName];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
    detailViewController.detailItem = [friends objectAtIndex:[indexPath row]];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [detailViewController release];
    [super dealloc];
}


@end

