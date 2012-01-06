//
//  LimitedWithdrawalExpenseFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LimitedWithdrawalExpenseFieldEditInfo.h"

#import "ExpenseInput.h"
#import "Account.h"
#import "StaticNameFieldCell.h"
#import "DataModelController.h"

@implementation LimitedWithdrawalExpenseFieldEditInfo

@synthesize account;
@synthesize expense;

-(id)initWithAccount:(Account*)theAccount andExpense:(ExpenseInput*)theExpense
{
	self = [super init];
	if(self)
	{
		assert(theAccount);
		self.account = theAccount;
		
		assert(theExpense);
		self.expense = theExpense;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[account release];
	[expense release];
}



- (NSString*)detailTextLabel
{
    return @"";
}

- (NSString*)textLabel
{
	return @"";
}

- (UIViewController*)fieldEditController
{
    assert(0);
    return nil;
    
}

- (BOOL)hasFieldEditController
{
    return FALSE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 30.0;
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
    return nil;
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    
    StaticNameFieldCell *cell = (StaticNameFieldCell *)[tableView 
		dequeueReusableCellWithIdentifier:STATIC_NAME_FIELD_CELL_IDENTIFIER];
    if (cell == nil) {
		cell = [[[StaticNameFieldCell alloc] init] autorelease];
    }    
    cell.staticName.text = self.expense.name;
	cell.staticName.textAlignment = UITextAlignmentLeft;
	
	if(true)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}        

    
	return cell;
    
}

- (BOOL)isSelected
{
	return [self.account.limitWithdrawalExpenses containsObject:self.expense]; 
}

- (void)updateSelection:(BOOL)isSelected
{
	if(isSelected)
	{
		[self.account addLimitWithdrawalExpensesObject:self.expense];
	}
	else
	{
		[self.account removeLimitWithdrawalExpensesObject:self.expense];
	}
	[[DataModelController theDataModelController] saveContext];

}




@end
