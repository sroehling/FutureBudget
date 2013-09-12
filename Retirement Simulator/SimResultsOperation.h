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

@protocol SimExecutionResultsDelegate;
@class SimResults;

@interface SimResultsOperation : NSOperation  <ProgressUpdateDelegate> {
    @private
        DataModelController *mainDmc;
        id<SimExecutionResultsDelegate> resultsDelegate;
    
        CGFloat currentSimProgress;
        SimResults *simResults;
}

@property(nonatomic,retain) DataModelController *mainDmc;
@property(nonatomic,assign) id<SimExecutionResultsDelegate> resultsDelegate;
@property(nonatomic,retain) SimResults *simResults;

-(id)initWithDataModelController:(DataModelController*)theMainDataModelController
              andResultsDelegate:(id<SimExecutionResultsDelegate>)theResultsDelegate;

@end

@protocol SimExecutionResultsDelegate <NSObject>

-(void)simResultsGenerated:(SimResults*)simResults;
-(void)updateSimProgress:(CGFloat)currentProgress;

@end
