//
//  SimResultsOperation.h
//  FutureBudget
//
//  Created by Steve Roehling on 9/10/13.
//
//

#import <Foundation/Foundation.h>
#import "ProgressUpdateDelegate.h"

@class DataModelController;


@interface SimResultsOperation : NSOperation  <ProgressUpdateDelegate> {
    @private
        DataModelController *resultsDmc;
        id<ProgressUpdateDelegate> mainThreadProgressDelegate;
        CGFloat currentSimProgress;
}

@property(nonatomic,retain) DataModelController *resultsDmc;
@property(nonatomic,retain) id<ProgressUpdateDelegate> mainThreadProgressDelegate;

-(id)initWithDataModelController:(DataModelController*)theResultsDataModelController
             andProgressDelegate:(id<ProgressUpdateDelegate>)theMainThreadProgressDelegate;


@end
