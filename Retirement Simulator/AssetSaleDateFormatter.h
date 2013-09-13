//
//  AssetSaleDateFormatter.h
//  FutureBudget
//
//  Created by Steve Roehling on 8/7/13.
//
//

#import <Foundation/Foundation.h>

#import "SimDateVisitor.h"
@class SimDate;
@class DateHelper;

@interface AssetSaleDateFormatter : NSObject <SimDateVisitor>
{
    @private
        NSString *formattedEndDate;
        DateHelper *dateHelper;
}

@property(nonatomic,retain) NSString *formattedEndDate;
@property(nonatomic,retain) DateHelper *dateHelper;

-(NSString*)formatSimDate:(SimDate*)theSimDate;

@end
