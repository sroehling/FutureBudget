//
//  DefaultScenarioFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultScenarioFieldEditInfo.h"

#import "StaticFieldEditInfo.h"
#import "DefaultScenario.h"
#import "LocalizationHelper.h"

@implementation DefaultScenarioFieldEditInfo

@synthesize defaultScenario;

-(id)initWithDefaultScen:(DefaultScenario*)defaultScen
{
	self = [super initWithManagedObj:defaultScen 
		andCaption:LOCALIZED_STR(@"SCENARIO_LIST_DEFAULT_SCENARIO_CAPTION") 
		andContent:@""];
	if(self)
	{
		assert(defaultScen != nil);
		self.defaultScenario = defaultScen;
	}
	return self;	
}

-(id)initWithManagedObj:(NSManagedObject *)theFieldObj andCaption:(NSString *)theCaption 
	andContent:(NSString *)theContent
{
	assert(0);
	return nil;
}

- (BOOL)isSelected
{
	return self.defaultScenario.isSelectedForSelectableObjectTableView;
}

- (void)updateSelection:(BOOL)isSelected
{
	self.defaultScenario.isSelectedForSelectableObjectTableView = isSelected;
}


-(void)dealloc
{
	[defaultScenario release];
	[super dealloc];
}


@end
