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

@interface AssetSaleDateFormatter : NSObject <SimDateVisitor>
{
    @private
        NSString *formattedEndDate;
}

@property(nonatomic,retain) NSString *formattedEndDate;

-(NSString*)formatSimDate:(SimDate*)theSimDate;

@end
