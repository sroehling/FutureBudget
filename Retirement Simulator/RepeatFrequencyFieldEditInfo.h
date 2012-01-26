//
//  RepeatFrequencyFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@class FormFieldWithSubtitleTableCell;
@class Scenario;
@class MultiScenarioInputValue;

@interface RepeatFrequencyFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private
		FormFieldWithSubtitleTableCell *freqCell;
}

@property(nonatomic,retain) FormFieldWithSubtitleTableCell *freqCell;

+ (RepeatFrequencyFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                                        andLabel:(NSString*)label;

+ (RepeatFrequencyFieldEditInfo*)createForScenario:(Scenario*)theScenario 
	andRepeatFreq:(MultiScenarioInputValue*)repeatFreq
                             andLabel:(NSString*)label;

@end
