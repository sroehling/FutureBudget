//
//  NeverEndDateFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StaticFieldEditInfo.h"
@class NeverEndDate;

@interface NeverEndDateFieldEditInfo : StaticFieldEditInfo {
    @private
		NeverEndDate *neverEndDate;
}

@property(nonatomic,retain) NeverEndDate *neverEndDate;

-(id)initWithNeverEndDate:(NeverEndDate*)theNeverEndDate
	andContent:(NSString*)content;

@end
