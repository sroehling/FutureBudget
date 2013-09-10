//
//  SimResults.h
//  FutureBudget
//
//  Created by Steve Roehling on 9/10/13.
//
//

#import <Foundation/Foundation.h>

@class Scenario;
@class SimEngine;

@interface SimResults : NSObject {
    @private
        NSMutableArray *endOfYearResults;
        Scenario *scenarioSimulated;
    
        NSInteger resultMinYear;
        NSInteger resultMaxYear;
        
        NSSet *assetsSimulated;
        NSSet *loansSimulated;
        NSSet *acctsSimulated;
        NSSet *incomesSimulated;
        NSSet *expensesSimulated;
        NSSet *taxesSimulated;
    
}

@property(nonatomic,retain) NSMutableArray *endOfYearResults;
@property(nonatomic,retain) Scenario *scenarioSimulated;

@property NSInteger resultMinYear;
@property NSInteger resultMaxYear;

@property(nonatomic,retain) NSSet *assetsSimulated;
@property(nonatomic,retain) NSSet *loansSimulated;
@property(nonatomic,retain) NSSet *acctsSimulated;
@property(nonatomic,retain) NSSet *incomesSimulated;
@property(nonatomic,retain) NSSet *expensesSimulated;
@property(nonatomic,retain) NSSet *taxesSimulated;


-(id)initWithSimEngine:(SimEngine*)simEngine;

@end
