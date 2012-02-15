//
//  NeverEndDateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NeverEndDateFieldEditInfo.h"
#import "NeverEndDate.h"
#import "LocalizationHelper.h"



@implementation NeverEndDateFieldEditInfo
@synthesize neverEndDate;

-(id)initWithNeverEndDate:(NeverEndDate*)theNeverEndDate
	andContent:(NSString*)content
{
	self = [super initWithManagedObj:theNeverEndDate 
		andCaption:@""
		andContent:content];
	if(self)
	{
		assert(theNeverEndDate != nil);
		self.neverEndDate = theNeverEndDate;
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
	return self.neverEndDate.isSelectedForSelectableObjectTableView;
}

- (void)updateSelection:(BOOL)isSelected
{
	self.neverEndDate.isSelectedForSelectableObjectTableView = isSelected;
}


-(void)dealloc
{
	[neverEndDate release];
	[super dealloc];
}

@end
