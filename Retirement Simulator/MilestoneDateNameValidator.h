//
//  MilestoneDateNameValidator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/7/13.
//
//

#import "TextFieldValidator.h"

@class DataModelController;
@class MilestoneDate;

@interface MilestoneDateNameValidator : TextFieldValidator
{
	@private
		MilestoneDate *currentMilestone;
		NSMutableSet *otherMilestoneNames;
}

@property(nonatomic,retain) MilestoneDate *currentMilestone;;
@property(nonatomic,retain) NSMutableSet *otherMilestoneNames;

-(id)initWithMilestone:(MilestoneDate *)theCurrentMilestone
		andDataModelController:(DataModelController*)theDmc;

@end
