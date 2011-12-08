//
//  EndOfYearInputResults.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Input;

@interface EndOfYearInputResults : NSObject {
    @private
		NSMutableDictionary *inputResultMap;
}

@property(nonatomic,retain) NSMutableDictionary *inputResultMap;

-(void)setResultForInput:(Input*)input andValue:(double)val;
-(double)getResultForInput:(Input*)input;

@end
