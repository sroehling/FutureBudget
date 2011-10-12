//
//  InputFormHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormPopulator.h"

@class MultiScenarioInputValue;
@class SectionInfo;
@class Scenario;

@interface InputFormPopulator : FormPopulator {
    @private
		Scenario *inputScenario;
}

@property(nonatomic,retain) Scenario *inputScenario;

-(id)initWithScenario:(Scenario*)theInputScenario;
-(id)initForNewObject:(BOOL)isNewObject;

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt;
	
-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
-(void)populatePercentField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
	
@end
