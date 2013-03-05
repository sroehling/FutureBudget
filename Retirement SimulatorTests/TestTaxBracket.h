//
//  TestTaxBracket.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/5/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

@class DataModelController;
@class SharedAppValues;
@class TaxInputTypeSelectionInfo;

@interface TestTaxBracket : SenTestCase
{
    @private
		DataModelController *coreData;
		SharedAppValues *sharedAppVals;
		TaxInputTypeSelectionInfo *taxCreator;
}

@property(nonatomic,retain) DataModelController *coreData;
@property(nonatomic,retain) SharedAppValues *sharedAppVals;
@property(nonatomic,retain) TaxInputTypeSelectionInfo *taxCreator;


@end
