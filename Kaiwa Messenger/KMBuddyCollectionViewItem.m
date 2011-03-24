//
//  KMBuddyCollectionItem.m
//  Kaiwa Messenger
//
//  Created by Jon Gilkison on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KMBuddyCollectionViewItem.h"


@implementation KMBuddyCollectionViewItem

- (void)doubleClick:(id)sender {
	if ([self collectionView] && [[self collectionView] delegate] && [[[self collectionView] delegate] respondsToSelector:@selector(doubleClick:)])
		[[[self collectionView] delegate] performSelector:@selector(doubleClick:) withObject:self];
}

@end
