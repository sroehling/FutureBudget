//
//  TestSimEngine.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// TODO - Additional tests needed, include (but not limited to):
//     - Stream of multiple events
//     - Event and results happen on same date
//     - Multiple results between events
//     - Multiple events between results

#import "SimEngine.h"

#import "TestSimEngine.h"
#import "TestSimEventCreator.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "InputCreationHelper.h"
#import "RelativeEndDate.h"
#import "DateHelper.h"

@implementation TestSimEngine

@synthesize coreData;
@synthesize testAppVals;

- (void)setUp
{
	self.coreData = [[[DataModelController alloc] initForInMemoryStorage] autorelease];
	self.testAppVals = [SharedAppValues createWithDataModelInterface:self.coreData];
	
	self.testAppVals.simStartDate = [DateHelper dateFromStr:@"2012-01-01"];
	
	// For testing purposes, default to 5 years (instead of 50)
	RelativeEndDate *theSimEndDate = [self.coreData createDataModelObject:RELATIVE_END_DATE_ENTITY_NAME];
	theSimEndDate.monthsOffset = [NSNumber numberWithInt:60];
	self.testAppVals.simEndDate = theSimEndDate;

}

- (void)tearDown
{
	[coreData release];
	[testAppVals release];
}


- (void)testSimEngine {
        
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
    NSLog(@"Starting sim engine test ...");
    
    SimEngine *simEngine = [[SimEngine alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals ];
    [simEngine.eventCreators addObject:[[TestSimEventCreator alloc]init]];
    [simEngine runSim];
    
    NSLog(@"... Done testing sim engine");
    
    [simEngine release];
    
}

@end
