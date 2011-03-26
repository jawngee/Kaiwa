
#import "MutNRLockArray.h"




@implementation MutNRLockArray


- (NSString *) description	{
	return [NSString stringWithFormat:@"<MutNRLockArray: %@>",array];
}
+ (id) arrayWithCapacity:(NSUInteger)c	{
	MutNRLockArray	*returnMe = [[MutNRLockArray alloc] initWithCapacity:0];
	if (returnMe == nil)
		return nil;
	return [returnMe autorelease];
}
- (NSMutableArray *) createArrayCopy	{
	NSMutableArray		*returnMe = [NSMutableArray arrayWithCapacity:0];
	for (ObjectHolder *objPtr in array)	{
		[returnMe addObject:objPtr];	//	THIS RETAINS THE OBJECT! HAVE TO RETURN A MUTABLE ARRAY!
	}
	return returnMe;
}
- (NSMutableArray *) lockCreateArrayCopyFromObjects	{
	NSMutableArray		*returnMe = nil;
	pthread_rwlock_rdlock(&arrayLock);
		returnMe = [self createArrayCopyFromObjects];
	pthread_rwlock_unlock(&arrayLock);
	return returnMe;
}
- (NSMutableArray *) createArrayCopyFromObjects	{
	NSMutableArray		*returnMe = [NSMutableArray arrayWithCapacity:0];
	for (id objPtr in array)	{
		if ([objPtr isKindOfClass:[ObjectHolder class]])	{
			id addMe = [objPtr object];
			if (addMe!=nil)
				[returnMe addObject:addMe];
		}
		else {
			[returnMe addObject:objPtr];
		}

	}
	return returnMe;	
}
- (void) addObject:(id)o	{
	if ([o isKindOfClass:[ObjectHolder class]])	{
		[super addObject:o];
		return;
	}
	ObjectHolder		*holder = [ObjectHolder createWithObject:o];
	[super addObject:holder];
}
- (void) addObjectsFromArray:(id)a	{
	if ((array!=nil) && (a!=nil) && ([a count]>0))	{
		//	if the array's another MutNRLockArray, i can simply use its items
		if ([a isKindOfClass:[MutNRLockArray class]])	{
			[array addObjectsFromArray:[a lockCreateArrayCopy]];
		}
		//	else if it's an MutLockArray
		else if ([a isKindOfClass:[MutLockArray class]])	{
			//	lock & get a copy of the array
			NSMutableArray		*copy = [a lockCreateArrayCopy];
			ObjectHolder		*tmpHolder = nil;
			if (copy!=nil)	{
				//	run through the copy, creating ObjectHolders for each item & adding them to me
				for (id anObj in copy)	{
					tmpHolder = [ObjectHolder createWithObject:anObj];
					if (tmpHolder != nil)
						[array addObject:tmpHolder];
				}
			}
		}
		//	else it's some other kind of generic array
		else	{
			//	run through the array, creating ObjectHolders for each itme & adding them to me
			ObjectHolder		*tmpHolder = nil;
			for (id anObj in a)	{
				tmpHolder = [ObjectHolder createWithObject:anObj];
				if (tmpHolder != nil)
					[array addObject:tmpHolder];
			}
		}
	}
}
- (void) replaceWithObjectsFromArray:(id)a	{
	if ((array!=nil) && (a!=nil))	{
		@try	{
			[array removeAllObjects];
			[self addObjectsFromArray:a];
		}
		@catch (NSException *err)	{
			NSLog(@"%\t\t%s - %@",__func__,err);
		}
	}
}
- (void) insertObject:(id)o atIndex:(NSUInteger)i	{
	ObjectHolder		*tmpHolder = [ObjectHolder createWithObject:o];
	[super insertObject:tmpHolder atIndex:i];
}
- (id) lastObject	{
	ObjectHolder		*objHolder = [super lastObject];
	return [objHolder object];
}
- (void) removeObject:(id)o	{
	long		indexOfObject = [self indexOfObject:o];
	if ((indexOfObject!=NSNotFound) && (indexOfObject>=0))
		[self removeObjectAtIndex:indexOfObject];
}
- (BOOL) containsObject:(id)o	{
	long		foundIndex = [self indexOfObject:o];
	if (foundIndex == NSNotFound)
		return NO;
	return YES;
}
- (id) objectAtIndex:(NSUInteger)i	{
	ObjectHolder	*returnMe = [super objectAtIndex:i];
	if (returnMe == nil)
		return nil;
	return [returnMe object];
}
- (NSArray *) objectsAtIndexes:(NSIndexSet *)indexes	{
	NSMutableArray		*returnMe = [NSMutableArray arrayWithCapacity:0];
	NSArray				*tmpArray = nil;
	
	if ((array!=nil) && (indexes!=nil))	{
		tmpArray = [array objectsAtIndexes:indexes];
		if (tmpArray != nil)	{
			for (ObjectHolder *objPtr in tmpArray)	{
				[returnMe addObject:[objPtr object]];
			}
		}
	}
	return returnMe;
}
- (NSUInteger) indexOfObject:(id)o	{
	if (o == nil)
		return NSNotFound;
	int				tmpIndex = 0;
	long			foundIndex = -1;
	NSEnumerator	*objIt;
	ObjectHolder	*objPtr;
	id				anObj;
	
	objIt = [array objectEnumerator];
	//	run through the array object holders while i haven't found the object i'm looking for
	while ((objPtr=[objIt nextObject]) && (foundIndex<0))	{
		//	get the object stored by the object holder
		anObj = [objPtr object];
		//	if the object in the object holder matches the passed object using isEqual:, i'm going to return it
		if ((anObj != nil) && ([o isEqual:anObj]))
			foundIndex = tmpIndex;
		++tmpIndex;
	}
	//	make sure i return NSNotFound instead of -1
	if (foundIndex < 0)
		foundIndex = NSNotFound;
	return foundIndex;
}
- (BOOL) containsIdenticalPtr:(id)o	{
	long		foundIndex = [self indexOfIdenticalPtr:o];
	if (foundIndex == NSNotFound)
		return NO;
	return YES;
}
- (long) indexOfIdenticalPtr:(id)o	{
	if (o == nil)
		return NSNotFound;
	int				tmpIndex = 0;
	long			foundIndex = -1;
	NSEnumerator	*objIt;
	ObjectHolder	*objPtr;
	id				anObj;
	
	objIt = [array objectEnumerator];
	//	run through the array object holders while i haven't found the object i'm looking for
	while ((objPtr=[objIt nextObject]) && (foundIndex<0))	{
		//	first, check to see if it's a match for an ObjectHolder- if it is, i can return right away
		if (objPtr == o)
			foundIndex = tmpIndex;
		//	get the object stored by the object holder
		anObj = [objPtr object];
		//	if the object in the object holder matches the passed object using isEqual:, i'm going to return it
		if ((anObj != nil) && (o  == anObj))
			foundIndex = tmpIndex;
		++tmpIndex;
	}
	//	make sure i return NSNotFound instead of -1
	if (foundIndex < 0)
		foundIndex = NSNotFound;
	return foundIndex;
}
- (void) removeIdenticalPtr:(id)o	{
	long		foundIndex = [self indexOfIdenticalPtr:o];
	if (foundIndex == NSNotFound)
		return;
	[self removeObjectAtIndex:foundIndex];
}


- (void) bruteForceMakeObjectsPerformSelector:(SEL)s	{
	if (array==nil)
		return;
	for (id anObj in array)	{
		id		actualObj = [anObj object];
		if (actualObj != nil)
			[actualObj performSelector:s];
	}
}
- (void) lockBruteForceMakeObjectsPerformSelector:(SEL)s	{
	if (array == nil)
		return;
	pthread_rwlock_rdlock(&arrayLock);
		[self bruteForceMakeObjectsPerformSelector:s];
	pthread_rwlock_unlock(&arrayLock);
}
- (void) bruteForceMakeObjectsPerformSelector:(SEL)s withObject:(id)o	{
	if (array==nil)
		return;
	for (id anObj in array)	{
		id		actualObj = [anObj object];
		if (actualObj != nil)
			[actualObj performSelector:s withObject:o];
	}
}
- (void) lockBruteForceMakeObjectsPerformSelector:(SEL)s withObject:(id)o	{
	if (array == nil)
		return;
	pthread_rwlock_rdlock(&arrayLock);
		[self bruteForceMakeObjectsPerformSelector:s withObject:o];
	pthread_rwlock_unlock(&arrayLock);
}


@end
