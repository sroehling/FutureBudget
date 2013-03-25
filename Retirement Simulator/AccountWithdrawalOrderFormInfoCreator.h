//
//  AccountWithdrawalOrderFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class Scenario;

@interface AccountWithdrawalOrderFormInfoCreator : NSObject <FormInfoCreator>
{
	@private
		Scenario *inputScenario;
}

@property(nonatomic,retain) Scenario *inputScenario;

-(id)initWithInputScenario:(Scenario*)theScenario;

@end
