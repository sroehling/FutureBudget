//
//  CollectionHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CollectionHelper.h"


@implementation CollectionHelper


+ (NSArray*)setToSortedArray:(NSSet*)theSet withKey:(NSString*)theKey
{
    assert(theKey != nil);
    assert([theKey length] > 0);
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:theKey ascending:YES] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];   
    

    return [theSet sortedArrayUsingDescriptors:sortDescriptors];
}

+ (void)sortMutableArrayInPlace:(NSMutableArray*)theArray withKey:(NSString*)sortKey 
	ascending:(BOOL)sortAscending
{
	assert(sortKey != nil);
	assert([sortKey length] > 0);
	assert(theArray != nil);
	

	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] 
			initWithKey:sortKey ascending:sortAscending] autorelease];
	NSArray *sortDescriptors = [[[NSArray alloc]
			initWithObjects:sortDescriptor, nil] autorelease];   

	[theArray sortUsingDescriptors:sortDescriptors];

}


@end
