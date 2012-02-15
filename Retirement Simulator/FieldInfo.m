//
//  FieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FieldInfo.h"


@implementation FieldInfo

@synthesize fieldLabel;
@synthesize fieldPlaceholder;
@synthesize isSelectedForSelectableObjectTableView;


-(id)initWithFieldLabel:(NSString*)theFieldLabel
			 andFieldPlaceholder:(NSString *)thePlaceholder
{
    self = [super init];
    if(self)
    {
        
        assert(theFieldLabel != nil); 
        assert([theFieldLabel length]>0);
        self.fieldLabel = theFieldLabel;
		
		assert(thePlaceholder != nil);
		assert([thePlaceholder length] > 0);
		self.fieldPlaceholder = thePlaceholder;
		       
        fieldAccessEnabled = TRUE;        
    }
    return self;
}

- (id)init
{
	assert(0);
	return nil;
}

- (id)getFieldValue
{
	assert(0); // must be overriden
	return nil;
}

- (void)setFieldValue:(NSObject*)newValue
{
	assert(0); // must be overridden
}

- (NSManagedObject*)managedObject
{
	assert(0); // must be overriden
	return nil;
}

- (NSManagedObject*)fieldObject
{
	assert(0); // must be overriden
	return nil;
}

- (BOOL)fieldIsInitializedInParentObject
{
	assert(0); // must be overriden
	return FALSE;
}

- (void)disableFieldAccess
{
    fieldAccessEnabled = FALSE;
}

- (NSString*)textLabel
{
    return self.fieldLabel;
}


- (void)dealloc {
    [fieldLabel release];
	[fieldPlaceholder release];
    [super dealloc];
}

@end
