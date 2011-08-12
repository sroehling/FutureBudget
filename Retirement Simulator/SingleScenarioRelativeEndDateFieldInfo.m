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
#import "RelativeEndDateInfo.h"

@implementation SingleScenarioRelativeEndDateFieldInfo


- (void)setFieldValue:(NSObject*)newValue
{
	
	assert([newValue isKindOfClass:[RelativeEndDateInfo class]]);
	RelativeEndDateInfo *newRelEndDateInfo = (RelativeEndDateInfo*)newValue;
	RelativeEndDate *existingRelEndDate = (RelativeEndDate*)[super getFieldValue];
	if(existingRelEndDate != nil)
	{
		[existingRelEndDate setWithRelEndDateInfo:newRelEndDateInfo];
	}
	else
	{
		RelativeEndDate *newRelEndDate = (RelativeEndDate*)
			[[DataModelController theDataModelController] insertObject:RELATIVE_END_DATE_ENTITY_NAME];
		[newRelEndDate setWithRelEndDateInfo:newRelEndDateInfo];
		[super setFieldValue:newRelEndDate];
	}
}

- (id)getFieldValue
{
	RelativeEndDate *theRelEndDate = (RelativeEndDate*)[super getFieldValue];
	assert(theRelEndDate != nil); // value must be set for current scenario or default
	
	return [theRelEndDate relEndDateInfo];
}

- (NSManagedObject*)fieldObject
{
	RelativeEndDate *theRelEndDate = (RelativeEndDate*)[super getFieldValue];
	assert(theRelEndDate != nil); // value must be set for current scenario or default
	return theRelEndDate;
}




@end
