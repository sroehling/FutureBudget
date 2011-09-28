//
//  CollectionHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CollectionHelper : NSObject {

}

+ (NSArray*)setToSortedArray:(NSSet*)theSet withKey:(NSString*)theKey;
+ (void)sortMutableArrayInPlace:(NSMutableArray*)theArray withKey:(NSString*)sortKey 
	ascending:(BOOL)sortAscending;
	
@end
