//
//  InputTypeSelectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InputTypeSelectionInfo : NSObject {
    @private
#warning Need to replace description with another name
    NSString *description;
}

@property(nonatomic,retain) NSString *description;

- (void)createInput; // must be overriden

@end

@interface ExpenseInputTypeSelectionInfo : InputTypeSelectionInfo 
{}
@end

@interface IncomeInputTypeSelectionInfo : InputTypeSelectionInfo 
{}
@end
