//
//  AccountWithdrawalOrderInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import <Foundation/Foundation.h>

@class Account;
@class MultiScenarioFixedValueFieldInfo;
@class DataModelController;
@class Scenario;

@interface AccountWithdrawalOrderInfo : NSObject
{
	@private
		Account *account;
		MultiScenarioFixedValueFieldInfo *withdrawalOrderFieldInfo;
		Scenario *inputScenario;
}

-(id)initWithAccount:(Account*)theAccount andDataModelController:(DataModelController*)theDmc
	andCurrentScenaro:(Scenario*)theCurrentScenario;

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) MultiScenarioFixedValueFieldInfo *withdrawalOrderFieldInfo;
@property(nonatomic,retain) Scenario *inputScenario;

-(NSComparisonResult)compareWithdrawalOrder:(AccountWithdrawalOrderInfo*)otherOrderInfo;

-(NSInteger)withdrawalOrder;
-(void)setWithdrawalOrder:(NSInteger)theOrder;
-(NSString*)withdrawalOrderCaption;

+(NSArray*)sortedWithdrawalOrderInfos:(DataModelController*)dataModelController
	underScenario:(Scenario*)inputScenario;
+(NSArray*)sortedWithdrawalOrderInfosFromAccountSet:(NSSet*)accounts
	andDmc:(DataModelController*)dataModelController
	underScenario:(Scenario*)inputScenario;

@end
