//
//  AssetSaleDateFormatter.m
//  FutureBudget
//
//  Created by Steve Roehling on 8/7/13.
//
//

#import "AssetSaleDateFormatter.h"
#import "RelativeEndDate.h"
#import "NeverEndDate.h"
#import "MilestoneDate.h"
#import "DateHelper.h"
#import "LocalizationHelper.h"

@implementation AssetSaleDateFormatter

@synthesize dateHelper;
@synthesize formattedEndDate;

-(void)dealloc
{
    [dateHelper release];
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.dateHelper = [[[DateHelper alloc] init] autorelease];
    }
    return self;
}

-(NSString*)formatSimDate:(SimDate*)theSimDate
{
    self.formattedEndDate = nil;
    
    [theSimDate acceptVisitor:self];
    
    assert(self.formattedEndDate != nil);
    return self.formattedEndDate;
}

- (void)visitMilestoneDate:(MilestoneDate*)milestoneDate
{
    self.formattedEndDate = [milestoneDate inlineDescription:self.dateHelper.mediumDateFormatter];
    
}

- (void)visitNeverEndDate:(NeverEndDate*)neverEndDate
{
    self.formattedEndDate =  LOCALIZED_STR(@"ASSET_NEVER_SELL_INLINE_DESC");
}

- (void)visitFixedDate:(FixedDate*)fixedDate
{
    self.formattedEndDate = [fixedDate inlineDescription:self.dateHelper.mediumDateFormatter];
    
}

- (void)visitRelativeEndDate:(RelativeEndDate*)relEndDate
{
   self.formattedEndDate = [relEndDate inlineDescription:self.dateHelper.mediumDateFormatter];
}


@end
