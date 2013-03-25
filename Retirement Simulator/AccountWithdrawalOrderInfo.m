//
//  AccountWithdrawalOrderInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import "AccountWithdrawalOrderInfo.h"
#import "MultiScenarioFixedValueFieldInfo.h"
#import "Account.h"
#import "Input.h"
#import "DataModelController.h"

@implementation AccountWithdrawalOrderInfo

@synthesize account;
@synthesize withdrawalOrderFieldInfo;
@synthesize inputScenario;

-(void)dealloc
{
	[account release];
	[withdrawalOrderFieldInfo release];
	[inputScenario release];
	[super dealloc];
}

-(id)initWithAccount:(Account*)theAccount andDataModelController:(DataModelController*)theDmc
	andCurrentScenaro:(Scenario*)theCurrentScenario
{
	self = [super init];
	if(self)
	{
		self.account = theAccount;
		self.inputScenario = theCurrentScenario;
	
		self.withdrawalOrderFieldInfo =
			[[[MultiScenarioFixedValueFieldInfo alloc] 
				initWithDataModelController:theDmc
				andFieldLabel:@"N/A" andFieldPlaceholder:@"N/A"
			andScenario:theCurrentScenario
				andInputVal:theAccount.withdrawalPriority] autorelease];

	}
	return self;
}

-(NSInteger)withdrawalOrder
{
	NSNumber *theOrder = [self.withdrawalOrderFieldInfo getFieldValue];
	assert(theOrder != nil);
	return [theOrder integerValue];
}

-(void)setWithdrawalOrder:(NSInteger)theOrder
{
	assert(theOrder > 0);
	NSLog(@"Changing withdrawal order for acct=%@ to %d",self.account.name,theOrder);
	[self.withdrawalOrderFieldInfo  setFieldValue:[NSNumber numberWithInteger:theOrder]];
	
}

-(NSString*)withdrawalOrderCaption
{
	return [NSString stringWithFormat:@"%d",self.withdrawalOrder];
}

-(NSComparisonResult)compareWithdrawalOrder:(AccountWithdrawalOrderInfo*)otherInfo
{
	NSInteger myWithdrawalOrder = [self withdrawalOrder];
	NSInteger otherWithdrawalOrder = [otherInfo withdrawalOrder];
	
	if(myWithdrawalOrder < otherWithdrawalOrder)
	{
		return NSOrderedAscending;
	}
	else if(myWithdrawalOrder > otherWithdrawalOrder)
	{
		return NSOrderedDescending;
	}
	return NSOrderedSame;
}


+(NSArray*)sortedWithdrawalOrderInfosFromAccountSet:(NSSet*)accounts
	andDmc:(DataModelController*)dataModelController
	underScenario:(Scenario*)inputScenario
{
	NSMutableArray *acctInfos = [[[NSMutableArray alloc] init] autorelease];
	for(Account *account in accounts)
	{    
		assert(account != nil);
				
		AccountWithdrawalOrderInfo *acctWithOrderInfo =
			[[[AccountWithdrawalOrderInfo alloc] initWithAccount:account
			andDataModelController:dataModelController
			andCurrentScenaro:inputScenario] autorelease];
				
		[acctInfos addObject:acctWithOrderInfo];

	}
	
	// Sort the accounts by their current withdrawal order
	NSArray *sortedInfos = [acctInfos sortedArrayUsingSelector:@selector(compareWithdrawalOrder:)];

	return sortedInfos;
}

+(NSArray*)sortedWithdrawalOrderInfos:(DataModelController*)dataModelController
	underScenario:(Scenario*)inputScenario
{


	NSSet *accounts = [dataModelController fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
			
	return [AccountWithdrawalOrderInfo sortedWithdrawalOrderInfosFromAccountSet:accounts andDmc:dataModelController underScenario:inputScenario];
}

@end
