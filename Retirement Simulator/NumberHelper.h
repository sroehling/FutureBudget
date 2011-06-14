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
    NSNumberFormatter *decimalFormatter;
    NSNumberFormatter *currencyFormatter;
    NSNumberFormatter *percentFormatter;
}

+(NumberHelper*)theHelper; // singleton

- (NSString*)stringFromNumber:(NSNumber*)theNumber;
- (BOOL)valueInRange:(NSInteger)value lower:(NSInteger)low upper:(NSInteger)up;

- (NSNumber*)displayValFromStoredVal:(NSNumber*)storedVal andFormatter:(NSNumberFormatter*)formatter;
- (NSString*)displayStrFromStoredVal:(NSNumber*)storedVal andFormatter:(NSNumberFormatter*)formatter;

@property(nonatomic,retain) NSNumberFormatter *currencyFormatter;
@property(nonatomic,retain) NSNumberFormatter *decimalFormatter;
@property(nonatomic,retain) NSNumberFormatter *percentFormatter;


@end
