//
//  SingleScenarioRelativeEndDateFieldInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SingleScenarioRelativeEndDateFieldInfo.h"
#import "RelativeEndDate.h"
#import "DataModelController.h"

@implementation SingleScenarioRelativeEndDateFieldInfo

@synthesize dataModelController;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
		andManagedObject:(NSManagedObject*)theManagedObject
               andFieldKey:(NSString*)theFieldKey
             andFieldLabel:(NSString*)theFieldLabel
			 andFieldPlaceholder:(NSString *)thePlaceholder
{
	self = [super initWithManagedObject:theManagedObject 
		andFieldKey:theFieldKey andFieldLabel:theFieldLabel andFieldPlaceholder:thePlaceholder];
	if(self)
	{
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
	}
	return self;
}

-(id)initWithManagedObject:(NSManagedObject*)theManagedObject
               andFieldKey:(NSString*)theFieldKey
             andFieldLabel:(NSString*)theFieldLabel
			 andFieldPlaceholder:(NSString *)thePlaceholder
{
	assert(0);
	return nil;
}

- (void)setFieldValue:(NSObject*)newValue
{
	
	assert([newValue isKindOfClass:[NSNumber class]]);
	RelativeEndDate *existingRelEndDate = (RelativeEndDate*)[super getFieldValue];
	if(existingRelEndDate != nil)
	{
		existingRelEndDate.monthsOffset = (NSNumber*)newValue;
	}
	else
	{
		RelativeEndDate *newRelEndDate = (RelativeEndDate*)
			[self.dataModelController insertObject:RELATIVE_END_DATE_ENTITY_NAME];
		newRelEndDate.monthsOffset = (NSNumber*)newValue;
		[super setFieldValue:newRelEndDate];
	}
}

- (id)getFieldValue
{
	RelativeEndDate *theRelEndDate = (RelativeEndDate*)[super getFieldValue];
	assert(theRelEndDate != nil); // value must be set for current scenario or default
	
	return theRelEndDate.monthsOffset;
}

- (NSManagedObject*)fieldObject
{
	RelativeEndDate *theRelEndDate = (RelativeEndDate*)[super getFieldValue];
	assert(theRelEndDate != nil); // value must be set for current scenario or default
	return theRelEndDate;
}

-(void)dealloc
{
	[dataModelController release];
	[super dealloc];
}




@end
