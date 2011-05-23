//
//  NumberHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NumberHelper : NSObject {
    @private
        NSNumberFormatter *numberFormatter;
}

+(NumberHelper*)theHelper; // singleton

- (NSString*)stringFromNumber:(NSNumber*)theNumber;
- (BOOL)valueInRange:(NSInteger)value lower:(NSInteger)low upper:(NSInteger)up;

@property(nonatomic,retain) NSNumberFormatter *numberFormatter;

@end
