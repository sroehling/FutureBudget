//
//  InputValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InputValue : NSManagedObject {
@private
}

// Inverse Relationships
@property (nonatomic, retain) NSSet* scenarioValInputValues;

// supportsDeletion is called by the UI to determine whether or not to allow
// deletion of this input value. The default is TRUE, but derived InputValue's
// can override as needed. For example, input values which are used as defaults
// should not support deletion.
- (BOOL)supportsDeletion;

@end
