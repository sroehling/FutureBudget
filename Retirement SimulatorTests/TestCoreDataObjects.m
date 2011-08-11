//
//  TestCoreDataObjects.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestCoreDataObjects.h"
#import "DateSensitiveValueChange.h"
#import "DateSensitiveValue.h"
#import "FixedDate.h"
#import "InMemoryCoreData.h"
#import "DateHelper.h"


@implementation TestCoreDataObjects

+ (DateSensitiveValueChange*)createTestValueChange:(InMemoryCoreData*)coreData 
										   andDate:(NSString*)dateStr andVal:(double)val
{
	
	DateSensitiveValueChange *valChange = (DateSensitiveValueChange*)[coreData createObj:DATE_SENSITIVE_VALUE_CHANGE_ENTITY_NAME];
	
	FixedDate *fixedStartDate = (FixedDate*) [coreData createObj:FIXED_DATE_ENTITY_NAME];
	fixedStartDate.date = [DateHelper dateFromStr:dateStr];
	
	valChange.startDate = fixedStartDate;
	valChange.newValue = [NSNumber numberWithDouble:val];
	return valChange;
}

@end
