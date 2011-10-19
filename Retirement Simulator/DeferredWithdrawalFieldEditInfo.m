//
//  DeferredWithdrawalFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeferredWithdrawalFieldEditInfo.h"
#import "Account.h"
#import "DeferredWithdrawalFormInfoCreator.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "ValueSubtitleTableCell.h"
#import "ColorHelper.h"
#import "LocalizationHelper.h"
#import "SimInputHelper.h"
#import "SharedAppValues.h"
#import "SimDate.h"
#import "DateHelper.h"
#import "MultiScenarioInputValue.h"
#import "MultiScenarioSimDate.h"

@implementation DeferredWithdrawalFieldEditInfo

@synthesize account;
@synthesize isNewAccount;
@synthesize valueCell;
@synthesize fieldLabel;

-(bool)deferredWithdrawalsEnabled
{
 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	return [SimInputHelper multiScenBoolVal:self.account.deferredWithdrawalsEnabled
		andScenario:currentScenario];
}


- (void) configureValueCell
{
	self.valueCell.caption.text = self.fieldLabel;
	self.valueCell.valueDescription.textColor = [ColorHelper blueTableTextColor];
	self.valueCell.valueDescription.text = [self detailTextLabel];
	
	if([self deferredWithdrawalsEnabled])
	{
		SimDate *deferDate = (SimDate*)[self.account.deferredWithdrawalDate.simDate getValueForCurrentOrDefaultScenario];
		assert(deferDate != nil);
		
	    NSString *deferDateDisplay = [deferDate 
					inlineDescription:[DateHelper theHelper].mediumDateFormatter];

		self.valueCell.valueSubtitle.text = [NSString stringWithFormat:
			LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_DEFER_DATE_SUBTITLE_FORMAT"),deferDateDisplay];
	}
	else
	{
		self.valueCell.valueSubtitle.text = @"";
	}
	
}

-(id)initWithAccount:(Account*)theAccount andFieldLabel:(NSString*)theFieldLabel
	andIsNewAccount:(BOOL)accountIsNew
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;
		
		assert(theFieldLabel != nil);
		self.fieldLabel  = theFieldLabel;
		
		self.isNewAccount = accountIsNew;
		
		
		self.valueCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
		self.valueCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.valueCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		[self configureValueCell];

	}
	return self;
}

-(id)init
{
	assert(0); // must init with account
}

- (NSString*) textLabel
{
    return @"";
}


- (NSString*)detailTextLabel
{
	if([self deferredWithdrawalsEnabled])
	{
		return LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAWALS_ENABLED");
	}
	else
	{
		return LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAWALS_DISABLED");
	}
}

- (UIViewController*)fieldEditController
{

	DeferredWithdrawalFormInfoCreator *dwFormInfoCreator = 
		[[[DeferredWithdrawalFormInfoCreator alloc] 
			initWithAccount:self.account andIsNewAccount:self.isNewAccount] autorelease];
	UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
	    initWithFormInfoCreator:dwFormInfoCreator] autorelease];
	return controller;	
}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{

	return [self.valueCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{

	[self configureValueCell];
    return self.valueCell;
}



- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
}

- (NSManagedObject*) managedObject
{
    return self.account;
}

- (void)dealloc
{
	[super dealloc];
	[account release];
	[valueCell release];
	[fieldLabel release];
}



@end
