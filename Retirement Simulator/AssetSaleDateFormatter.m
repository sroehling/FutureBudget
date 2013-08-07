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

@synthesize formattedEndDate;

-(NSString*)formatSimDate:(SimDate*)theSimDate
{
    self.formattedEndDate = nil;
    
    [theSimDate acceptVisitor:self];
    
    assert(self.formattedEndDate != nil);
    return self.formattedEndDate;
}

- (void)visitMilestoneDate:(MilestoneDate*)milestoneDate
{
    self.formattedEndDate = [milestoneDate inlineDescription:[DateHelper theHelper].mediumDateFormatter];
    
}

- (void)visitNeverEndDate:(NeverEndDate*)neverEndDate
{
    self.formattedEndDate =  LOCALIZED_STR(@"ASSET_NEVER_SELL_INLINE_DESC");
}

- (void)visitFixedDate:(FixedDate*)fixedDate
{
    self.formattedEndDate = [fixedDate inlineDescription:[DateHelper theHelper].mediumDateFormatter];
    
}

- (void)visitRelativeEndDate:(RelativeEndDate*)relEndDate
{
   self.formattedEndDate = [relEndDate inlineDescription:[DateHelper theHelper].mediumDateFormatter];
}


@end
