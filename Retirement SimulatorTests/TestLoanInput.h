//
//  TestLoanInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 1

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

@class DataModelController;
@class SharedAppValues;

@interface TestLoanInput : SenTestCase {
    @private
		DataModelController *coreData;
		SharedAppValues *testAppVals;
}

@property(nonatomic,retain) DataModelController *coreData;
@property(nonatomic,retain) SharedAppValues *testAppVals;

@end
