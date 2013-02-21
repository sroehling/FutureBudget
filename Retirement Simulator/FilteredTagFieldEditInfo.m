//
//  FilteredTagFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/20/13.
//
//

#import "FilteredTagFieldEditInfo.h"
#import "SharedAppValues.h"

@implementation FilteredTagFieldEditInfo

@synthesize sharedAppVals;

-(void)dealloc
{
	[sharedAppVals release];
	[super dealloc];
}

-(id)initWithSharedAppVals:(SharedAppValues*)theSharedAppVals andInputTag:(InputTag*)theTag
{
	self = [super initWithTag:theTag];
	if(self)
	{
		self.sharedAppVals = theSharedAppVals;
	}
	return self;
}

- (BOOL)isSelected
{
	return [self.sharedAppVals.filteredTags containsObject:self.inputTag];
}

- (void)updateSelection:(BOOL)isSelected
{

	if(isSelected)
	{
		[self.sharedAppVals addFilteredTagsObject:self.inputTag];
	}
	else
	{
		[self.sharedAppVals removeFilteredTagsObject:self.inputTag];
	}
}


@end
