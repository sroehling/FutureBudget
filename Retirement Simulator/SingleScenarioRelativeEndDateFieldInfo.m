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
			[[DataModelController theDataModelController] insertObject:RELATIVE_END_DATE_ENTITY_NAME];
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




@end
