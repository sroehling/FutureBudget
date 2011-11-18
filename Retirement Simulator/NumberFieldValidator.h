//
//  NumberFieldValidator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NumberFieldValidator : NSObject {
    @private
		NSString *validationFailedMsg;
}

- (id)initWithValidationMsg:(NSString*)validationMsg;
-(BOOL)validateNumber:(NSNumber *)theNumber;


@property(nonatomic,retain) NSString *validationFailedMsg;

@end
