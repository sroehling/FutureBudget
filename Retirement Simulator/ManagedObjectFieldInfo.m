//
//  ManagedObjectFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ManagedObjectFieldInfo.h"
#import "DataModelController.h"

@implementation ManagedObjectFieldInfo

@synthesize fieldKey,managedObjectWithField;


-(id)initWithManagedObject:(NSManagedObject*)theManagedObject
               andFieldKey:(NSString*)theFieldKey
             andFieldLabel:(NSString*)theFieldLabel
			 andFieldPlaceholder:(NSString *)thePlaceholder
{
    self = [super initWithFieldLabel:theFieldLabel andFieldPlaceholder:thePlaceholder];
    if(self)
    {
        assert(theFieldKey != nil);
        assert([theFieldKey length]>0);
        self.fieldKey = theFieldKey;
        
        assert(theManagedObject != nil);
        self.managedObjectWithField = theManagedObject;
        
        fieldAccessEnabled = TRUE;
        
    }
    return self;
}

-(id) init
{
    assert(0); // should not call this version of init.
}


- (id)getFieldValue
{
    // Note that valueForKey will raise an exception
    // if fieldKey is not supported.
    assert(fieldAccessEnabled);
    id fieldValue = [self.managedObject  valueForKey:self.fieldKey];
    assert(fieldValue != nil);
    return fieldValue;
}

- (BOOL)fieldIsInitializedInParentObject
{
    id fieldValue = [self.managedObject  valueForKey:self.fieldKey];
    if(fieldValue != nil)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}


- (void)setFieldValue:(NSObject*)newValue
{
    if(fieldAccessEnabled)
    {
        [self.managedObject setValue:newValue forKey:self.fieldKey];		
    }
	// TBD - Is a save needed here?
}

-(NSManagedObject*)managedObject
{
	return self.managedObjectWithField;
}


- (void)dealloc {
    [fieldKey release];
    [managedObjectWithField release];
    [super dealloc];
}


@end
