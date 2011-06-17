//
//  VariableValueRuntimeInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableValueListMgr.h"

@class CashFlowInput;

@interface VariableValueRuntimeInfo : NSObject {
	@private
		NSNumberFormatter *valueFormatter;
		NSString *valueTitle;
		NSString *valueVerb;
		NSString *periodDesc;
		id<VariableValueListMgr> listMgr;
		
}

@property(nonatomic,retain) NSNumberFormatter *valueFormatter;
@property(nonatomic,retain) NSString *valueTitle;
@property(nonatomic,retain) NSString *valueVerb;
@property(nonatomic,retain) NSString *periodDesc;
@property(nonatomic,retain) id<VariableValueListMgr> listMgr;

- (id) initWithFormatter:(NSNumberFormatter*)formatter
	andValueTitle:(NSString*)title andValueVerb:(NSString*)verb
	andPeriodDesc:(NSString*)thePeriodDesc andListMgr:(id<VariableValueListMgr>)listMgr;
	
- (NSString *)inlinePeriodDesc;


+ (VariableValueRuntimeInfo*)createForCashflowAmount:(CashFlowInput*)cashFlow;
+ (VariableValueRuntimeInfo*)createForInflationRate;

@end
