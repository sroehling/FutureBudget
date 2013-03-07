//
//  MilestoneDateNameValidator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/7/13.
//
//

#import "MilestoneDateNameValidator.h"
#import "LocalizationHelper.h"
#import "CoreDataHelper.h"
#import "MilestoneDate.h"
#import "DataModelController.h"


@implementation MilestoneDateNameValidator


@synthesize currentMilestone;
@synthesize otherMilestoneNames;

-(void)dealloc
{
	[currentMilestone release];
	[otherMilestoneNames release];
	[super dealloc];
}

-(id)initWithMilestone:(MilestoneDate *)theCurrentMilestone andDataModelController:(DataModelController *)theDmc
{
	self = [super initWithValidationMsg:LOCALIZED_STR(@"MILESTONE_NAME_VALIDATION_MSG")];
	if(self)
	{
		assert(theCurrentMilestone != nil);
		self.currentMilestone = theCurrentMilestone;
		
		self.otherMilestoneNames = [[[NSMutableSet alloc] init] autorelease];
		NSSet *allMilestones = [theDmc fetchObjectsForEntityName:MILESTONE_DATE_ENTITY_NAME];
		for(MilestoneDate *milestone in allMilestones)
		{
			if(![CoreDataHelper sameCoreDataObjects:self.currentMilestone comparedTo:milestone])
			{
				[self.otherMilestoneNames addObject:milestone.name];
			}
		}
		
		
	}
	return self;
}

-(BOOL)validateText:(NSString *)theText
{
	if(theText.length == 0)
	{
		return FALSE;
	}

	if([self.otherMilestoneNames member:theText])
	{
		return FALSE;
	}
	
	return TRUE;
}


@end
