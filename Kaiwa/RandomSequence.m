//
//  RandomSequence.m
//  Baby Banger
//
//  Created by Paul Suh on Tue Sep 17 2002.
//  Copyright (c) 2002. All rights reserved.
//

#import "RandomSequence.h"

static RandomSequence *	defaultRandomSequence;
static RandomSequence * currentRandomSequence;

static NSLock * lock;

long generateSeed();

@interface RandomSequence ( Globals )

+ (void) initialize;
- (void) lock;

@end


@implementation RandomSequence

- (id) init
{
    return [self initWithSeed: generateSeed() ];
}
- (id) initWithSeed: (long) newSeed
{
    if ( self = [super init] ) {

        // note: the current RandomSequence object (if there is one) will store its
        // own state vector, and so we don't have to worry about saving it
        [lock lock];
        stateVector = (char *) malloc( STATE_VECTOR_SIZE );
        initstate( newSeed, stateVector, STATE_VECTOR_SIZE );

        currentRandomSequence = self;
        [lock unlock];
    }
    return self;
}

- (void) reseed
{
    [self reseedWithSeed: generateSeed() ];
}
- (void) reseedWithSeed: (long) newSeed
{
    [self lock];
    srandom( newSeed );
    [lock unlock];
}

- (long) randomValue
{
    long result;
    // make sure that the random seed is set up using my state vector
    [self lock];
    result = random();
    [lock unlock];
    return result;
}
- (long) randomValueBetweenLowerValue: (long) lowerValue andUpperValue: (long) upperValue
{
    // very crude algorithm with distribution problems, especially as
    // the difference lowerValue to upperValue gets large relative to
    // the size of a long
    
    return ([self randomValue] % ( upperValue - lowerValue + 1 )) + lowerValue;
}


+ (long) randomValue {
    return [[RandomSequence defaultRandomSequence] randomValue];
}
+ (long) randomValueBetweenLowerValue: (long) lowerValue andUpperValue: (long) upperValue {
    return [[RandomSequence defaultRandomSequence] randomValueBetweenLowerValue: lowerValue andUpperValue: upperValue];
}

+ (RandomSequence *) defaultRandomSequence
{
    if ( defaultRandomSequence == nil ) {
        defaultRandomSequence = [[RandomSequence alloc] init];
    }
    return defaultRandomSequence;
}

+ (RandomSequence *) currentRandomSequence
{
    return currentRandomSequence;
}

@end



@implementation RandomSequence ( Globals )

+ (void) initialize
{
    lock = [[NSLock alloc] init];
}

- (void) lock
{
    [lock lock];
    setstate( stateVector );
    currentRandomSequence = self;
}


@end



// Utility function to generate a seed
// Using the lowest 4 bits (1 hex digit) of the microseconds
// value called 8 times ensures variability in all 8
// places of the value
long generateSeed() {

    UnsignedWide i;
    long result;
    
    Microseconds( &i );
    result = (i.lo & 0x0000000F) << 28;

    Microseconds( &i );
    result = ((i.lo & 0x0000000F) << 24) | result;

    Microseconds( &i );
    result = ((i.lo & 0x0000000F) << 20) | result;

    Microseconds( &i );
    result = ((i.lo & 0x0000000F) << 16) | result;

    Microseconds( &i );
    result = ((i.lo & 0x0000000F) << 12) | result;

    Microseconds( &i );
    result = ((i.lo & 0x0000000F) << 8) | result;

    Microseconds( &i );
    result = ((i.lo & 0x0000000F) << 4) | result;

    Microseconds( &i );
    result = (i.lo & 0x0000000F) | result;
    
    return result;
}