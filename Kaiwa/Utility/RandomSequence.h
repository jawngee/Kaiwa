//
//  RandomSequence.h
//  Baby Banger
//
//  Created by Paul Suh on Tue Sep 17 2002.
//  Copyright (c) 2002. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STATE_VECTOR_SIZE	256


@interface RandomSequence : NSObject {

    char *	stateVector;
}

- (id) init;
- (id) initWithSeed: (long) seed;
- (void) reseed;
- (void) reseedWithSeed: (long) newSeed;

- (long) randomValue;
- (long) randomValueBetweenLowerValue: (long) lowerValue andUpperValue: (long) upperValue;

+ (long) randomValue;
+ (long) randomValueBetweenLowerValue: (long) lowerValue andUpperValue: (long) upperValue;

+ (RandomSequence *) defaultRandomSequence;
+ (RandomSequence *) currentRandomSequence;

@end

