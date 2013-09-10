//
//  SimResults.m
//  FutureBudget
//
//  Created by Steve Roehling on 9/10/13.
//
//

#import "SimResults.h"
#import "SimEngine.h"
#import "FiscalYearDigest.h"
#import "SimParams.h"
#import "EndOfYearDigestResult.h"
#import "InputSimInfoCltn.h"


@implementation SimResults

@synthesize endOfYearResults;
@synthesize scenarioSimulated;

@synthesize resultMaxYear;
@synthesize resultMinYear;

@synthesize assetsSimulated;
@synthesize loansSimulated;
@synthesize acctsSimulated;
@synthesize incomesSimulated;
@synthesize expensesSimulated;
@synthesize taxesSimulated;


-(void)dealloc
{
	
	[endOfYearResults release];
 	[scenarioSimulated release];
   
	[assetsSimulated release];
	[loansSimulated release];
	[acctsSimulated release];
	[incomesSimulated release];
	[expensesSimulated release];
	[taxesSimulated release];
	
	
	[super dealloc];
}


-(id)initWithSimEngine:(SimEngine*)simEngine
{
    self = [super init];
    if(self)
    {
        self.scenarioSimulated = simEngine.simParams.simScenario;
        self.endOfYearResults = simEngine.digest.savedEndOfYearResults;
        
        NSInteger minYear = NSIntegerMax;
        NSInteger maxYear = 0;
        for(EndOfYearDigestResult *eoyResult in self.endOfYearResults)
        {
            NSInteger resultYear = [eoyResult yearNumber];
            minYear = MIN(minYear, resultYear);
            maxYear = MAX(maxYear, resultYear);
            
        }
        assert(maxYear >= minYear);
        self.resultMaxYear = maxYear;
        self.resultMinYear = minYear;
        
        self.assetsSimulated = simEngine.simParams.assetInfo.inputsSimulated;
        self.loansSimulated = simEngine.simParams.loanInfo.inputsSimulated;
        self.acctsSimulated = simEngine.simParams.acctInfo.inputsSimulated;
        self.incomesSimulated = simEngine.simParams.incomeInfo.inputsSimulated;
        self.expensesSimulated = simEngine.simParams.expenseInfo.inputsSimulated;
        self.taxesSimulated = [simEngine.simParams.taxInputCalcs taxesSimulated];
        
    }
    return self;
}


@end
