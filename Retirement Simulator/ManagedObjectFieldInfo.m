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

@synthesize fieldLabel,fieldKey,managedObject;

-(id)initWithManagedObject:(NSManagedObject*)theManagedObject
               andFieldKey:(NSString*)theFieldKey
             andFieldLabel:(NSString*)theFieldLabel
{
    self = [super init];
    if(self)
    {
        assert(theFieldKey != nil);
        assert([theFieldKey length]>0);
        self.fieldKey = theFieldKey;
        
        assert(theFieldLabel != nil); 
        assert([theFieldLabel length]>0);
        self.fieldLabel = theFieldLabel;

        assert(theManagedObject != nil);
        self.managedObject = theManagedObject;
        
        fieldAccessEnabled = TRUE;
        
    }
    return self;
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
    assert(fieldAccessEnabled);
    
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

- (void)disableFieldAccess
{
    fieldAccessEnabled = FALSE;
}

- (void)setFieldValue:(id)newValue
{
    if(fieldAccessEnabled)
    {
        [self.managedObject setValue:newValue forKey:self.fieldKey];
        [[DataModelController theDataModelController] saveContext];
    }
}


- (NSString*)textLabel
{
    return self.fieldLabel;
}


- (void)dealloc {
    [super dealloc];
    [fieldLabel release];
    [fieldKey release];
    [managedObject release];
}


@end
