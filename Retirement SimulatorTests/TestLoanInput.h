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

@class InMemoryCoreData;
@class TestCoreDataObjects;

@interface TestLoanInput : SenTestCase {
    @private
		InMemoryCoreData *coreData;
		TestCoreDataObjects *testObjs;
}

@property(nonatomic,retain) InMemoryCoreData *coreData;
@property(nonatomic,retain) TestCoreDataObjects *testObjs;

@end
